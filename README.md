# Table of Contents

[Step 1. Deploy shared disks](#step-1.-deploy-shared-disks)

[Step 2. Attach shared disk to VMs](#step-2.-attach-shared-disk-to-vms)

[Step 3. Initialize shared disk](#step-3.-initialize-shared-disk)

[Step 4. Add the Failover Clustering
Feature](#step-4.-add-the-failover-clustering-feature)

[Step 5. Run the Failover Cluster Validation
Wizard](#step-5.-run-the-failover-cluster-validation-wizard)

[Step 6. Create the Windows Server 2019 Failover Cluster
(WSFC)](#step-6.-create-the-windows-server-2019-failover-cluster-wsfc)

[Step 7. Add a file share for a cluster
quorum](#step-7.-add-a-file-share-for-a-cluster-quorum)

[Step 8. Configuring the Cluster Quorum
Settings](#step-8.-configuring-the-cluster-quorum-settings)

[Step 9. Install a SQL Server 2019 Failover Clustered Instance
(FCI)](#step-9.-install-a-sql-server-2019-failover-clustered-instance-fci)

[Step 10. Install Secondary (Failover) Cluster
Node](#step-10.-install-secondary-failover-cluster-node)

[References](#references)

# Step 1. Deploy shared disks

1.  Sign in to the Azure portal.

2.  Search for and Select Disks.

3.  Select **+ Create** to create a new managed disk.

4.  Fill in the details and select an appropriate region, then select
    Change size.

![Screenshot of the create a managed disk pane, change size
highlighted..](media/image1.png){width="7.5in"
height="5.145138888888889in"}

5.  Select the premium SSD size and SKU that you want and select **OK**.

![Screenshot of the disk SKU, premium LRS and ZRS SSD SKUs
highlighted.](media/image2.png){width="4.566666666666666in"
height="5.116666666666666in"}

6.  Proceed through the deployment until you get to the **Advanced**
    pane.

7.  Select **Yes** for **Enable shared disk** and select the amount of
    **Max shares** as **2**.

![Screenshot of the Advanced pane, Enable shared disk highlighted and
set to yes.](media/image3.png){width="7.5in"
height="1.6666666666666667in"}

8.  Select Review + Create.

9.  Repeat 1\~8 to deploy another two shared disks.

# Step 2. Attach shared disk to VMs

1.  Select the first SQL Server VM in the Azure portal.

2.  Select **Disks** in the **Settings** pane.

3.  Select **Attach existing disks** to attach the shared disk to the
    VM.

4.  Choose the shared disk from the **Disk name** drop-down.

5.  Select **Save**.

6.  Repeat 1\~5 on second SQL Server VM.

# Step 3. Initialize shared disk

1.  Use Remote Desktop Protocol (RDP) to connect to the first SQL Server
    VM.

2.  From inside the VM, open the **Start** menu and type
    **diskmgmt.msc** in the search box to open the **Disk Management**
    console.

3.  Disk Management recognizes that you have a new, uninitialized disk
    and the **Initialize Disk** window appears.

4.  Verify the new disk is selected and then select **OK** to initialize
    it.

5.  The new disk appears as **unallocated**. Right-click anywhere on the
    disk and select **New simple volume**. The **New Simple Volume
    Wizard** window opens.

6.  Proceed through the wizard, keeping all of the defaults, and when
    you\'re done select **Finish**.

7.  Close **Disk Management**.

8.  A pop-up window appears notifying you that you need to format the
    new disk before you can use it. Select **Format disk**.

9.  In the **Format new disk** window, check the settings, and then
    select **Start**.

10. A warning appears notifying you that formatting the disks erases all
    of the data. Select **OK**.

11. When the formatting is complete, select **OK**.

12. Repeat 1\~11 on second SQL Server VM.

![disk management](media/image4.png){width="7.5in"
height="4.473611111111111in"}

# Step 4. Add the Failover Clustering Feature

1.  Connect to the first SQL Server VM.

2.  Open the **Server Manager Dashboard** and click the **Add roles and
    features** link. This will run the **Add Roles and Features
    Wizard**.

![add server roles and features](media/image5.png){width="7.5in"
height="4.493055555555555in"}

3.  Click through the different dialog boxes until you reach the
    **Select features** dialog box. In the **Select features** dialog
    box, select the **Failover Clustering** checkbox.

![failover clustering feature](media/image6.png){width="7.5in"
height="4.5in"}

When prompted with the **Add features that are required for Failover
Clustering** dialog box, click **Add Features**. Click **Next**.

![add roles and features](media/image7.png){width="4.325in"
height="4.333333333333333in"}

4.  In the **Confirm installation selections** dialog box, click
    **Install** to confirm the selection and proceed to do the
    installation. You may need to reboot the server after adding this
    feature.

![confirm installation selections](media/image8.png){width="7.5in"
height="4.473611111111111in"}

5.  Repeat 1\~4 on the second SQL Server VM.

# Step 5. Run the Failover Cluster Validation Wizard

1.  Connect to the first SQL Server VM.

2.  Launch **Failover Cluster Manager** from the **Server Manager
    dashboard**.

![server manager](media/image9.png){width="7.5in"
height="4.459722222222222in"}

3.  In the **Failover Cluster Management** console, under the
    **Management** section, click the **Validate Configuration** link.
    This will run the **Validate a Configuration Wizard**.

![failover cluster manager](media/image10.png){width="7.5in"
height="4.473611111111111in"}

4.  In the **Select Servers or a Cluster** dialog box, enter the
    hostnames of the servers that you want to add as nodes of your WSFC.
    Click **Next**.

![failover cluster
manager](media/image11.png){width="6.966666666666667in"
height="4.833333333333333in"}

5.  In the **Testing Options** dialog box, accept the default option
    **Run all tests (recommended)** and click **Next**. This will run
    all the necessary tests to validate whether the nodes are OK for the
    WSFC.

![failover cluster
manager](media/image12.png){width="6.958333333333333in"
height="4.825in"}

6.  In the **Confirmation** dialog box, click **Next**. This will run
    all the necessary validation tests.

![failover cluster
manager](media/image13.png){width="6.966666666666667in"
height="4.833333333333333in"}

7.  In the **Summary** dialog box, verify that all the selected checks
    return successful results.

![failover cluster
manager](media/image14.png){width="6.958333333333333in"
height="4.833333333333333in"}

8.  To create the WSFC using the servers you\'ve just validated, select
    the **Create the cluster now using the validated nodes\...**
    checkbox and click **Finish**.

# Step 6. Create the Windows Server 2019 Failover Cluster (WSFC)

1.  Within the **Failover Cluster Manager** console, under the
    **Management** section, click the **Create Cluster\...** link. This
    will run the **Create Cluster Wizard**.

![failover cluster manager](media/image15.png){width="7.5in"
height="4.466666666666667in"}

2.  In the **Select Servers** dialog box, enter the hostnames of the
    servers that you want to add as nodes of your WSFC. Click **Next**.

![failover cluster
manager](media/image16.png){width="6.958333333333333in"
height="4.725in"}

3.  In the **Access Point for Administering the Cluster** dialog box,
    enter the virtual hostname and IP address that you will use to
    administer the WSFC. Click **Next**. Note that because the servers
    are within the same network subnet, only one virtual IP address is
    needed. This is a typical configuration for local high availability.

![failover cluster
manager](media/image17.png){width="6.958333333333333in"
height="4.725in"}

4.  In the **Confirmation** dialog box, click **Next**. This will
    configure Failover Clustering on both servers that will act as nodes
    in your WSFC, add the configured shared storage, add Active
    Directory and DNS entries for the WSFC virtual server name.

![failover cluster manager](media/image18.png){width="6.95in"
height="4.741666666666666in"}

5.  In the **Summary** dialog box, verify that the report returns
    successful results. Click **Finish**.

![failover cluster manager](media/image19.png){width="6.975in"
height="4.725in"}

6.  Verify that the quorum configuration is using **Node and Disk
    Majority - Witness: Cluster Disk n**. Since all the shared disks
    will be used for the SQL Server failover clustered instance, you
    need to configure a file share as a witness type.

![failover cluster manager](media/image20.png){width="7.5in"
height="4.459722222222222in"}

# Step 7. Add a file share for a cluster quorum

1.  In this deployment ticket, we will use the Domain Controller (DC) as
    a file share witness. Connect to the DC by using a remote desktop
    session.

2.  In **Server Manager**, select **Tools**. Open **Computer
    Management**.

3.  Select **Shared Folders**.

4.  Right-click **Shares**, and then select **New Share**.

![A screenshot of a computer Description automatically
generated](media/image21.png){width="3.884931102362205in"
height="2.1872265966754156in"}

Use the **Create a Shared Folder Wizard** to create a share.

5.  On the **Folder Path** page, select **Browse**. Locate or create a
    path for the shared folder, and then select **Next**.

6.  On the **Name, Description, and Settings** page, verify the share
    name and path. Select **Next**.

7.  On the **Shared Folder Permissions** page, set **Customize
    permissions**. Select **Custom**.

8.  In the **Customize Permissions** dialog, select **Add**.

9.  Make sure that the account that\'s used to create the cluster have
    **Modify** permissions to this shared folder.

![failover cluster manager](media/image22.png){width="3.775in"
height="4.658333333333333in"}

# Step 8. Configuring the Cluster Quorum Settings

1.  Open the **Failover Cluster Management** console.

2.  Select the name of the WSFC you have just created. Right-click,
    select **More Actions**, and click **Configure Cluster Quorum
    Settings\...** This will open the **Configure Cluster Quorum
    Wizard**.

![failover cluster manager](media/image23.png){width="7.5in"
height="4.5in"}

3.  In the **Select Quorum Configuration Option** dialog box, select the
    **Select the quorum witness** option. Click **Next**.

![failover cluster
manager](media/image24.png){width="6.941666666666666in"
height="4.833333333333333in"}

4.  In the **Select Quorum Witness** dialog box, select the **Configure
    a file share witness** option. Click **Next**.

![failover cluster
manager](media/image25.png){width="6.966666666666667in"
height="4.808333333333334in"}

5.  In the **Configure File Share Witness** dialog box, provide the file
    share location that you want your WSFC to use as the witness. Click
    **Next**.

![failover cluster
manager](media/image26.png){width="6.966666666666667in"
height="4.808333333333334in"}

6.  In the **Confirmation** dialog box, verify that the file share
    configuration for the witness is correct. Click **Next**.

![failover cluster
manager](media/image27.png){width="6.958333333333333in"
height="4.791666666666667in"}

7.  In the **Summary** dialog box, verify that the entire configuration
    is successful. Click **Finish**.

![failover cluster
manager](media/image28.png){width="6.958333333333333in"
height="4.825in"}

You can verify that the cluster quorum setting is now configured to use
the file share witness by looking at the **Cluster Core Resources**
section.

![failover cluster manager](media/image29.png){width="7.5in"
height="4.446527777777778in"}

# Step 9. Install a SQL Server 2019 Failover Clustered Instance (FCI)

1.  Connect to the first SQL Server VM.

2.  Run **setup.exe** from the SQL Server 2019 installation media to
    launch **SQL Server Installation Center**. Click on the
    **Installation** link on the left-hand side.

3.  Click the **New SQL Server failover cluster installation** link.
    This will run the SQL Server 2019 Setup wizard.

![failover cluster setup](media/image30.png){width="7.5in"
height="4.473611111111111in"}

4.  In the **Product Key** dialog box, enter the product key that came
    with your installation media and click **Next**.

![failover cluster setup](media/image31.png){width="7.5in"
height="4.473611111111111in"}

5.  In the **License Terms** dialog box, click the **I accept the
    license terms** check box and click **Next**.

![failover cluster setup](media/image32.png){width="7.5in"
height="4.5in"}

6.  In the **Global Rules** dialog box, validate that the checks return
    successful results and click **Next**.

![failover cluster setup](media/image33.png){width="7.5in"
height="4.5in"}

7.  In the **Microsoft Update** dialog box, click **Next**.

![failover cluster setup](media/image34.png){width="7.5in"
height="4.473611111111111in"}

8.  In the **Install Failover Cluster Rules** dialog box, validate that
    the checks return successful results. Click **Next**.

![sql server 2019 cluster setup](media/image35.png){width="7.5in"
height="4.506944444444445in"}

9.  In the **Feature Selection** dialog box, select the following
    components: **Database Engine Services** and **Client Tools
    Connectivity**. Click **Next**.

![failover cluster setup](media/image36.png){width="7.5in"
height="4.459722222222222in"}

10. In the **Feature Rules** dialog box, verify that all the rules have
    passed. If the rules returned a few warnings, make sure you fix them
    before proceeding with the installation. Click **Next**.

![failover cluster setup](media/image37.png){width="7.5in"
height="4.479861111111111in"}

11. In the **Instance Configuration** dialog box, provide a value for
    the SQL Server Network Name. Click **Next**.

![failover cluster setup](media/image38.png){width="7.5in"
height="4.479861111111111in"}

12. In the **Cluster Resource Group** dialog box, check the resources
    available on your WSFC. This tells you that a new Resource Group
    will be created on your WSFC for the SQL Server FCI. To specify the
    SQL Server cluster resource group name, you can either use the
    drop-down box to specify an existing group to use or type the name
    of a new group to create it. Click **Next**.

![failover cluster setup](media/image39.png){width="7.5in"
height="4.466666666666667in"}

13. In the **Cluster Disk Selection** dialog box, select the available
    disk groups that are on the WSFC for the SQL Server FCI to use.
    Click **Next**.

![failover cluster setup](media/image40.png){width="7.5in"
height="4.479861111111111in"}

14. In the **Cluster Network Configuration** dialog box, enter the IP
    address and subnet mask values that your SQL Server FCI will use.
    Select the **IPv4** checkbox under the **IP Type** column as you
    will be using a static IP address. Click **Next**.

![failover cluster setup](media/image41.png){width="7.5in"
height="4.506944444444445in"}

15. In the **Server Configuration** dialog box, provide the credentials
    for the SQL Server service accounts in the **Service Accounts** tab.
    Make sure that both the SQL Server Agent and SQL Server Database
    Engine services have a **Startup Type** of Manual. The WSFC will
    take care of stopping and starting these services. Select the
    checkbox **Grant Perform Volume Maintenance Task** privilege to SQL
    Server Database Engine Service. Click **Next**.

![failover cluster setup](media/image42.png){width="7.5in"
height="4.479861111111111in"}

16. In the **Database Engine Configuration** dialog box, under the
    **Server Configuration** tab,

Select **Windows authentication mode** in the **Authentication Mode**
section. If required, you can change it later after the installation is
complete.

Add the currently logged on user to be a part of the SQL Server
administrators group by clicking the **Add Current User** button in the
**Specify SQL Server Administrators** section. You can also add Active
Directory domain accounts or security groups as necessary.

![failover cluster setup](media/image43.png){width="7.5in"
height="4.473611111111111in"}

17. In the **Data Directories** tab, specify the location of the data
    files, the log files, and the backup files. Click **Next**.

![failover cluster setup](media/image44.png){width="7.5in"
height="4.459722222222222in"}

18. In the **Feature Configuration Rules** dialog box, verify that all
    checks are successful. Click **Next**.

![failover cluster setup](media/image45.png){width="7.5in"
height="4.479861111111111in"}

19. In the **Ready to Install** dialog box, verify that all
    configuration settings are correct. Click **Install** to proceed
    with the installation.

![failover cluster setup](media/image46.png){width="7.5in"
height="4.5in"}

20. In the **Complete** dialog box, click **Close**. This concludes the
    installation of a SQL Server 2019 FCI.

![failover cluster setup](media/image47.png){width="7.5in"
height="4.466666666666667in"}

# Step 10. Install Secondary (Failover) Cluster Node

1.  Connect to the second SQL Server VM.

2.  Run setup.exe from the SQL Server 2019 installation media to launch
    **SQL Server Installation Center**. Click on the **Installation**
    link on the left-hand side.

3.  Click the **Add node to a SQL Server failover cluster** link. This
    will run the SQL Server 2019 Setup wizard.

![sql server 2019 cluster setup](media/image48.png){width="7.5in"
height="4.5in"}

4.  In the **Product Key** dialog box, enter the product key that came
    with your installation media and click **Next**.

![sql server 2019 cluster setup](media/image49.png){width="7.5in"
height="4.473611111111111in"}

5.  In the **License Terms** dialog box, click the **I accept the
    license terms** check box and click **Next**.

![sql server 2019 cluster setup](media/image50.png){width="7.5in"
height="4.5in"}

6.  In the **Global Rules** dialog box, validate that the checks return
    successful results and click **Next**.

![sql server 2019 cluster setup](media/image51.png){width="7.5in"
height="4.479861111111111in"}

7.  In the **Microsoft Update** dialog box, click **Next**.

![sql server 2019 cluster setup](media/image52.png){width="7.5in"
height="4.473611111111111in"}

8.  In the **Add Node Rules** dialog box, validate that the checks
    return successful results. Click **Next**.

![sql server 2019 cluster setup](media/image35.png){width="7.5in"
height="4.506944444444445in"}

9.  In the **Cluster Node Configuration** dialog box, validate that the
    information for the existing SQL Server 2019 FCI that you installed
    and configured in Step 6 is correct. Click **Next**.

![sql server 2019 cluster setup](media/image53.png){width="7.5in"
height="4.473611111111111in"}

10. In the **Cluster Network Configuration** dialog box, validate that
    the IP address information is the same as the one you provided in
    Step 6. Click **Next**.

![sql server 2019 cluster setup](media/image54.png){width="7.5in"
height="4.5in"}

11. In the **Service Accounts** dialog box, verify that the information
    is the same as what was used to configure the first node. Provide
    the appropriate credentials for the corresponding SQL Server service
    accounts. Select the **Grant Perform Volume Maintenance Task
    privilege to SQL Server Database Engine Service** checkbox.
    **Click** Next.

![sql server 2019 cluster setup](media/image55.png){width="7.5in"
height="4.473611111111111in"}

12. In the **Feature Rules** dialog box, verify that all checks are
    successful. Click **Next**.

![sql server 2019 cluster setup](media/image56.png){width="7.5in"
height="4.5in"}

13. In the **Ready to Add Node** dialog box, verify that all
    configuration settings are correct. Click **Install** to proceed
    with the installation.

![sql server 2019 cluster setup](media/image57.png){width="7.5in"
height="4.473611111111111in"}

14. In the **Complete** dialog box, click **Close**. This concludes
    adding a node to an existing SQL Server 2017 FCI.

![sql server 2019 cluster setup](media/image58.png){width="7.5in"
height="4.506944444444445in"}

# References

1.  Enable share disk\
    <https://learn.microsoft.com/en-us/azure/virtual-machines/disks-shared-enable?tabs=azure-portal>

2.  Create an FCI with Azure shared disks (SQL Server on Azure VMs)\
    <https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/failover-cluster-instance-azure-shared-disks-manually-configure?view=azuresql-vm>

3.  Tutorial: Manually configure an availability group - SQL Server on
    Azure VMs\
    <https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/availability-group-manually-configure-prerequisites-tutorial-single-subnet?view=azuresql-vm>

4.  Step-by-step Installation of SQL Server 2019 on a Windows Server
    2019 Failover Cluster\
    <https://www.mssqltips.com/sqlservertip/6539/stepbystep-installation-of-sql-server-2019-on-a-windows-server-2019-failover-cluster-part-1/>
