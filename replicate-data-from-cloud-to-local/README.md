# Contents {#contents .TOC-Heading}

[Replicate Azure SQL Database to On-Prem SQL Server
[1](#replicate-azure-sql-database-to-on-prem-sql-server)](#replicate-azure-sql-database-to-on-prem-sql-server)

[Replicate AWS RDS for MySQL to On-Prem MySQL
[1](#replicate-aws-rds-for-mysql-to-on-prem-mysql)](#replicate-aws-rds-for-mysql-to-on-prem-mysql)

[Replicate GCP CloudSQL for MySQL to On-Prem MySQL
[2](#replicate-gcp-cloudsql-for-mysql-to-on-prem-mysql)](#replicate-gcp-cloudsql-for-mysql-to-on-prem-mysql)

# Replicate Azure SQL Database to On-Prem SQL Server

1.  Create a storage account, then create a container for storing
    database backup file (.bacpac).

2.  Navigate to the overview page of Azure SQL Database you want to
    export, click "export" to export this database to previously created
    container.

3.  Download backup file to local computer.

4.  Open SQL Server Management Studio (SSMS), connect to target SQL
    Server, right click "Databases" and then click "Import Data-tier
    Application".

5.  Follow the Import Data-tier Application wizard, choose downloaded
    backup file, designate target database name.

6.  Wait for the import progress finished.

References:\
<https://youtu.be/WfyJ5o0KkT8?si=CBfatRY8CFW8-UG7>

# Replicate AWS RDS for MySQL to On-Prem MySQL

1.  Confirm that [automated
    backups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html#USER_WorkingWithAutomatedBackups.Enabling)
    are turned on for the DB instance that you want to replicate. In
    this example, the DB instance is **RDS-active**.

2.  Create a [read
    replica](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html#USER_ReadRepl.Create)
    of the DB instance using the same configuration. In this example,
    the replica is **RDS-standby**.

3.  Log in to the **RDS-standb**y DB instance, and confirm that the
    replica is caught up with **RDS-active**:\
    mysql\> show slave status \\G

**Note:** The **seconds_behind_master** must be **0**, which means there
is no replica lag.

4.  [Stop
    replication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/mysql-stored-proc-replicating.html)
    on **RDS-standby**:\
    mysql\> call mysql.rds_stop_replication;

5.  Record data from the replica, and then note the -log_file and
    -log_position parameters:\
    mysql\> show slave status \\G

**Note:** The **-log_file** is the value of **Relay_Master_Log_File**,
and **-log_position** is the value of **Exec_Master_Log_Pos**.

6.  Exit the terminal, and use mysqldump (or a similar utility) to
    create a backup of **RDS-standby** that will be replicated to the
    target server. In this example, the target on-premises server is
    **MySQL-target**.\
    \$ mysqldump -h hostname -u username -p dbname \>
    backup_file_name.sql

7.  After you create the backup, transfer the backup file to the target
    on-premises server by logging in to **MySQL-target**.

8.  Create a new database, and then restore the database using dumpfile
    to the new external DB instance:\
    \$ mysql -h hostname -u username -p dbname \< backup_file_name.sql

9.  Log in to the **RDS-active** DB instance, set up a replication user,
    and then grant the necessary privileges to the user. Make sure to
    replace **repl_user** with your own replication username.\
    mysql\> create user repl_user@\'%\' identified by \'repl_user\';\
    mysql\>grant replication slave, replication client on \*.\* to
    repl_user@\'%\';\
    mysql\>show grants for repl_user@\'%\';

10. Log in to the target DB instance, and then stop the MySQL server.

11. Modify the **my.cnf file** parameters to point to your unique server
    ID and the name of the database that you want to replicate from the
    DB instance. For example, **server_id=2** and
    **replicate-do-db=test**.

12. Save the file.

13. Restart MySQL server on **MySQL-target**.

14. Establish a connection to the **RDS-active** DB instance. To do
    this, run the following command on **MySQL-target**:\
    mysql\> change master to
    master_host=\'rds-endpoint\',master_user=\'repl_user\',
    master_password=\'password\', master_log_file=\'mysql-bin.000001\',
    master_log_pos= 107;

15. Confirm that **MySQL-target** can connect to **RDS-active**.

16. Log in to MySQL-target, and start the replication:\
    mysql\> start slave;

Check that the replication is synchronizing between **RDS-active** and
**MySQL-target**:\
mysql\> Show slave status\\G

17. After the seconds behind master equals zero, you can delete the
    **RDS-standby** DB instance.

References:\
<https://repost.aws/knowledge-center/replicate-amazon-rds-mysql-on-premises>\
<https://severalnines.com/blog/migrating-amazon-rds-mysql-or-mariadb-to-on-prem-server/>

# Replicate GCP CloudSQL for MySQL to On-Prem MySQL

1.  Creating a Replication Slave User. Log in to the Google Cloud
    Platform -\> Databases -\> SQL -\> pick the MySQL instance -\> Users
    -\> Add User Account and enter the required details:

![Picture1](https://github.com/mars0426/Azure-Labs/assets/42570850/9f27bb66-2d6d-4685-99d6-95c12b434458)

The 202.187.194.255 is the slave public IP address located in our
on-premises that is going to replicate from this instance.

2.  Configure the client's SSL certificates. Go to Connections -\>
    Configure SSL client certificates -\> Create a client certificate:

![Picture2](https://github.com/mars0426/Azure-Labs/assets/42570850/37de245d-deed-46d8-ad6e-5e7ba3c6a9eb)

Download the above files (server-ca.pem, client-cert.pem and
client-key.pem) and store them inside the slave server. To simplify the
process, all of the above certificates and key file will be put under a
directory called "gcloud-certs":

\$ mkdir -p /root/gcloud-certs \# put the certs/key here

Make sure the permissions are correct, especially the private key file,
client-key.pem:

\$ chmod 600 /root/gcloud-certs/client-key.pem

3.  Take a mysqldump backup from our Google Cloud SQL MySQL 5.7 instance
    securely:

\$ mysqldump -uroot -p

-h 35.198.197.171

\--ssl-ca=/root/gcloud-certs/server-ca.pem

\--ssl-cert=/root/gcloud-certs/client-cert.pem

\--ssl-key=/root/gcloud-certs/client-key.pem

\--single-transaction

\--all-databases

\--triggers

\--routines \> fullbackup.sql

4.  Configure the Slave (Local) Server. On the slave server, install
    MySQL 5.7 for Debian 10:

\$ echo \'deb http://repo.mysql.com/apt/debian/ buster mysql-5.7\' \>
/etc/apt/sources.list.d/mysql.list

\$ apt-key adv \--keyserver pgp.mit.edu \--recv-keys 5072E1F5

\$ apt update

\$ apt -y install mysql-community-server

Then, add the following lines under the \[mysqld\] section inside
/etc/mysql/my.cnf (or any other relevant MySQL configuration file):

server-id = 1111 \# different value than the master

log_bin = binlog

log_slave_updates = 1

expire_logs_days = 7

binlog_format = ROW

gtid_mode = ON

enforce_gtid_consistency = 1

sync_binlog = 1

report_host = 202.187.194.255 \# IP address of this slave

Restart the MySQL server to apply the above changes:

\$ systemctl restart mysql

Restore the mysqldump backup on this server:

\$ mysql -uroot -p \< fullbackup.sql

Login to the slave\'s MySQL server as MySQL root user and run the
following statement:

mysql\> UPDATE mysql.user SET Super_priv = \'Y\', File_priv = \'Y\'
WHERE User = \'root\';

Flush the privileges table:

mysql\> FLUSH PRIVILEGES;

Exit the current terminal and re-login again. Run the following command
to verify that the root user now has the highest level of privileges:

mysql\> SHOW GRANTS FOR root@localhost;\
+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\
\| Grants for root@localhost \|\
+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\
\| GRANT ALL PRIVILEGES ON \*.\* TO \'root\'@\'localhost\' WITH GRANT
OPTION \|

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+

5.  Set up the Replication Link. Copy the gcloud directory into
    /etc/mysql and assign the correct permission and ownership:

\$ mkdir -p /etc/mysql

\$ cp /root/gcloud-certs /etc/mysql

\$ chown -Rf mysql:mysql /etc/mysql/gcloud-certs

On the slave server, configure the replication link as below:

mysql\> CHANGE MASTER TO MASTER_HOST = \'35.198.197.171\',

MASTER_USER = \'slave\',

MASTER_PASSWORD = \'slavepassword\',

MASTER_AUTO_POSITION = 1,

MASTER_SSL = 1,

MASTER_SSL_CERT = \'/etc/mysql/gcloud-certs/client-cert.pem\',

MASTER_SSL_CA = \'/etc/mysql/gcloud-certs/server-ca.pem\',

MASTER_SSL_KEY = \'/etc/mysql/gcloud-certs/client-key.pem\';

Then, start the replication slave:

mysql\> START SLAVE;

Make sure the Slave_IO_Running and Slave_SQL_Running values are \'Yes\',
as well as Seconds_Behind_Master should be 0, which means the slave has
caught up with the master.

Verify if our slave host is part of the replication from the master\'s
point-of-view. Login to the SQL Cloud instance as root:

\$ mysql -uroot -p

-h 35.198.197.171

\--ssl-ca=/root/gcloud-certs/server-ca.pem

\--ssl-cert=/root/gcloud-certs/client-cert.pem

\--ssl-key=/root/gcloud-certs/client-key.pem

And run the following statement:

mysql\> SHOW SLAVE HOSTS;

\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\* 1. row
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

Server_id: 1111

Host: 202.187.194.255

Port: 3306

Master_id: 2272712871

Slave_UUID: b1dabe58-14e6-11eb-840f-0800278dc04d

References:

<https://severalnines.com/blog/migrating-from-google-cloud-sql-to-mysql-onprem-server/>
