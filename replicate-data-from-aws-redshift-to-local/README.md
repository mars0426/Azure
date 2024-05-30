Method 1: Export from Redshift and import to Local DB

Step 1. Unload the Redshift tables to Amazon S3 as CSV files.

We can quickly export our data from Redshift to CSV with some relatively
simple SQL. We log into the Redshift console and connect to a database.
Once connected, we can start running SQL queries. The basic syntax to
export your data is as below.

UNLOAD (\'SELECT \* FROM table_name\')

TO \'s3://object-path/name-prefix\'

IAM_ROLE \'arn:aws:iam::\<aws-account-id\>:role/\<role-name\>\'

CSV;

Step 2. Copy or move those unloaded files to local server.

Step 3. Load local CSV files into MySQL tables using LOAD command in
MySQL.

Create a new SQL tab and input the following command.

![Import CSV to MySQL via SQL statements in
Workbench](media/image1.png){width="6.5in"
height="1.9694444444444446in"}

LOAD DATA LOCAL INFILE \'C:/\<PATH TO YOUR FILE\>/concerts-2023.csv\'\
INTO TABLE concerts2\
FIELDS TERMINATED BY \',\'\
ENCLOSED BY \'\"\'\
LINES TERMINATED BY \'\\n\'\
IGNORE 1 ROWS
(\`Date\`,\`Band\`,\`ConcertName\`,\`Country\`,\`City\`,\`Location\`,\`LocationAddress\`);

Method 2: With the help of [Skyvia](https://skyvia.com/)

To migrate a database from Amazon Redshift to MySQL using Skyvia, we can
follow these general steps: Step 1. Sign Up and Configure Skyvia:

-   Sign up for a Skyvia account.

-   Connect to Amazon Redshift database as a source and MySQL database
    as a target within the Skyvia platform.

Step 2. Set Up Data Transfer:

-   Define the tables, data, and specific mapping for the migration.

-   Configure any necessary data transformations or filtering if needed.

Step 3. Run Data Migration:

-   Execute the data migration job to transfer data from Amazon Redshift
    to MySQL.

<!-- -->

-   Skyvia allows to schedule data migration jobs for regular updates if
    required.

Step 4. Monitor and Verify:

-   Monitor the migration process to ensure that it is running smoothly
    and without errors.

-   Verify the data in MySQL database to confirm that it matches the
    data in Redshift.
