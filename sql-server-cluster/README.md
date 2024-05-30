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

![Picture1](https://github.com/mars0426/Azure-Labs/assets/42570850/0422ea4e-9005-4442-8850-e79dc31c90bb)

5.  Select the premium SSD size and SKU that you want and select **OK**.

![Picture2](https://github.com/mars0426/Azure-Labs/assets/42570850/9efdb885-5e0c-48b8-a7b7-a3633214ab00)

6.  Proceed through the deployment until you get to the **Advanced**
    pane.

7.  Select **Yes** for **Enable shared disk** and select the amount of
    **Max shares** as **2**.

![Picture3](https://github.com/mars0426/Azure-Labs/assets/42570850/6b466fdd-9019-438d-b637-953e2e39caf6)

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

![Picture4](https://github.com/mars0426/Azure-Labs/assets/42570850/096e5013-3a51-4843-b1ff-98b6f4c108dd)

# Step 4. Add the Failover Clustering Feature

1.  Connect to the first SQL Server VM.

2.  Open the **Server Manager Dashboard** and click the **Add roles and
    features** link. This will run the **Add Roles and Features
    Wizard**.

![Picture5](https://github.com/mars0426/Azure-Labs/assets/42570850/4401b4f9-1906-4119-b0a7-c537ff563e71)

3.  Click through the different dialog boxes until you reach the
    **Select features** dialog box. In the **Select features** dialog
    box, select the **Failover Clustering** checkbox.

![Picture6](https://github.com/mars0426/Azure-Labs/assets/42570850/c5c6e84f-85e5-4058-b828-e91069b19434)

When prompted with the **Add features that are required for Failover
Clustering** dialog box, click **Add Features**. Click **Next**.

![Picture7](https://github.com/mars0426/Azure-Labs/assets/42570850/cebe7c6a-4631-479c-a006-466121580f83)

4.  In the **Confirm installation selections** dialog box, click
    **Install** to confirm the selection and proceed to do the
    installation. You may need to reboot the server after adding this
    feature.

![Picture8](https://github.com/mars0426/Azure-Labs/assets/42570850/53e1c096-dfc7-4bfc-a66a-a7e3cb36af7f)

5.  Repeat 1\~4 on the second SQL Server VM.

# Step 5. Run the Failover Cluster Validation Wizard

1.  Connect to the first SQL Server VM.

2.  Launch **Failover Cluster Manager** from the **Server Manager
    dashboard**.

![Picture9](https://github.com/mars0426/Azure-Labs/assets/42570850/58de4704-6f68-442f-95ec-730a93319ddd)

3.  In the **Failover Cluster Management** console, under the
    **Management** section, click the **Validate Configuration** link.
    This will run the **Validate a Configuration Wizard**.

![Picture10](https://github.com/mars0426/Azure-Labs/assets/42570850/5d2cfa18-023f-46b1-95e9-fae393da0fae)

4.  In the **Select Servers or a Cluster** dialog box, enter the
    hostnames of the servers that you want to add as nodes of your WSFC.
    Click **Next**.

![Picture11](https://github.com/mars0426/Azure-Labs/assets/42570850/bf2c0bf8-3c66-41e4-bc08-9d7b8c4c419e)

5.  In the **Testing Options** dialog box, accept the default option
    **Run all tests (recommended)** and click **Next**. This will run
    all the necessary tests to validate whether the nodes are OK for the
    WSFC.

![Picture12](https://github.com/mars0426/Azure-Labs/assets/42570850/59608fbb-9f98-4720-866d-434053bf52fd)

6.  In the **Confirmation** dialog box, click **Next**. This will run
    all the necessary validation tests.

![Picture13](https://github.com/mars0426/Azure-Labs/assets/42570850/aff5e6ed-6281-4c0d-93e5-2eee37a2da9d)

7.  In the **Summary** dialog box, verify that all the selected checks
    return successful results.

![Picture14](https://github.com/mars0426/Azure-Labs/assets/42570850/93a41914-8b99-4e91-971a-25e7c94f4639)

8.  To create the WSFC using the servers you\'ve just validated, select
    the **Create the cluster now using the validated nodes\...**
    checkbox and click **Finish**.

# Step 6. Create the Windows Server 2019 Failover Cluster (WSFC)

1.  Within the **Failover Cluster Manager** console, under the
    **Management** section, click the **Create Cluster\...** link. This
    will run the **Create Cluster Wizard**.

![Picture15](https://github.com/mars0426/Azure-Labs/assets/42570850/339c3fee-bc30-4e22-a82e-ed639b41f709)

2.  In the **Select Servers** dialog box, enter the hostnames of the
    servers that you want to add as nodes of your WSFC. Click **Next**.

![Picture16](https://github.com/mars0426/Azure-Labs/assets/42570850/c6ac78f6-ce07-418f-9c23-27b234e0e7ae)

3.  In the **Access Point for Administering the Cluster** dialog box,
    enter the virtual hostname and IP address that you will use to
    administer the WSFC. Click **Next**. Note that because the servers
    are within the same network subnet, only one virtual IP address is
    needed. This is a typical configuration for local high availability.

![Picture17](https://github.com/mars0426/Azure-Labs/assets/42570850/a5759efd-f06e-4498-bdc7-4d9100bbeef8)

4.  In the **Confirmation** dialog box, click **Next**. This will
    configure Failover Clustering on both servers that will act as nodes
    in your WSFC, add the configured shared storage, add Active
    Directory and DNS entries for the WSFC virtual server name.

![Picture18](https://github.com/mars0426/Azure-Labs/assets/42570850/87728705-18e8-482a-91a8-5fa9452ef297)

5.  In the **Summary** dialog box, verify that the report returns
    successful results. Click **Finish**.

![Picture19](https://github.com/mars0426/Azure-Labs/assets/42570850/57e219a5-2bfb-46e4-bf11-0c6824c26afe)

6.  Verify that the quorum configuration is using **Node and Disk
    Majority - Witness: Cluster Disk n**. Since all the shared disks
    will be used for the SQL Server failover clustered instance, you
    need to configure a file share as a witness type.

![Picture20](https://github.com/mars0426/Azure-Labs/assets/42570850/d5e8e974-0d70-4aa6-9362-ca8070e4222e)

# Step 7. Add a file share for a cluster quorum

1.  In this deployment ticket, we will use the Domain Controller (DC) as
    a file share witness. Connect to the DC by using a remote desktop
    session.

2.  In **Server Manager**, select **Tools**. Open **Computer
    Management**.

3.  Select **Shared Folders**.

4.  Right-click **Shares**, and then select **New Share**.

![Picture21](https://github.com/mars0426/Azure-Labs/assets/42570850/d80ddb28-13fc-4c9d-9b76-cce861e330a0)

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

![Picture22](https://github.com/mars0426/Azure-Labs/assets/42570850/b552cc69-d335-476f-8ac0-7ce67479f0bb)

# Step 8. Configuring the Cluster Quorum Settings

1.  Open the **Failover Cluster Management** console.

2.  Select the name of the WSFC you have just created. Right-click,
    select **More Actions**, and click **Configure Cluster Quorum
    Settings\...** This will open the **Configure Cluster Quorum
    Wizard**.

![Picture23](https://github.com/mars0426/Azure-Labs/assets/42570850/7f9387d4-96d8-4e2f-934d-b3261c58cf31)

3.  In the **Select Quorum Configuration Option** dialog box, select the
    **Select the quorum witness** option. Click **Next**.

![Picture24](https://github.com/mars0426/Azure-Labs/assets/42570850/fb10a610-51dd-4755-9fca-b37ad98287b0)

4.  In the **Select Quorum Witness** dialog box, select the **Configure
    a file share witness** option. Click **Next**.

![Picture25](https://github.com/mars0426/Azure-Labs/assets/42570850/ac22db6d-80d4-48a9-94c6-e63b825f2044)

5.  In the **Configure File Share Witness** dialog box, provide the file
    share location that you want your WSFC to use as the witness. Click
    **Next**.

![Picture26](https://github.com/mars0426/Azure-Labs/assets/42570850/b1774fdf-516f-4233-9d25-77c00921407f)

6.  In the **Confirmation** dialog box, verify that the file share
    configuration for the witness is correct. Click **Next**.

![Picture27](https://github.com/mars0426/Azure-Labs/assets/42570850/07fbe303-59c2-4a89-a349-8d3a168a1b6f)

7.  In the **Summary** dialog box, verify that the entire configuration
    is successful. Click **Finish**.

![Picture28](https://github.com/mars0426/Azure-Labs/assets/42570850/06a1cef2-06e8-495e-b566-8736a436e914)

You can verify that the cluster quorum setting is now configured to use
the file share witness by looking at the **Cluster Core Resources**
section.

![Picture29](https://github.com/mars0426/Azure-Labs/assets/42570850/0ba24e74-2852-4e4f-8739-ae9ac7bb90ea)

# Step 9. Install a SQL Server 2019 Failover Clustered Instance (FCI)

1.  Connect to the first SQL Server VM.

2.  Run **setup.exe** from the SQL Server 2019 installation media to
    launch **SQL Server Installation Center**. Click on the
    **Installation** link on the left-hand side.

3.  Click the **New SQL Server failover cluster installation** link.
    This will run the SQL Server 2019 Setup wizard.

![Picture30](https://github.com/mars0426/Azure-Labs/assets/42570850/c1b7acc2-9138-4446-99ca-582847b7c8a8)

4.  In the **Product Key** dialog box, enter the product key that came
    with your installation media and click **Next**.

![Picture31](https://github.com/mars0426/Azure-Labs/assets/42570850/bd0c1d1f-1e9c-4ce0-b4c9-17276c9b5f0d)

5.  In the **License Terms** dialog box, click the **I accept the
    license terms** check box and click **Next**.

![Picture32](https://github.com/mars0426/Azure-Labs/assets/42570850/a54428c1-ebec-423a-bfcf-693f38395f94)

6.  In the **Global Rules** dialog box, validate that the checks return
    successful results and click **Next**.

![Picture33](https://github.com/mars0426/Azure-Labs/assets/42570850/d3207b80-63d6-4a17-8cb8-b0dfd975a392)

7.  In the **Microsoft Update** dialog box, click **Next**.

![Picture34](https://github.com/mars0426/Azure-Labs/assets/42570850/e207f0ac-cfd5-452e-9e30-6b766702242b)

8.  In the **Install Failover Cluster Rules** dialog box, validate that
    the checks return successful results. Click **Next**.

![Picture35](https://github.com/mars0426/Azure-Labs/assets/42570850/e2189777-039b-4f5d-8694-42bc856085f0)

9.  In the **Feature Selection** dialog box, select the following
    components: **Database Engine Services** and **Client Tools
    Connectivity**. Click **Next**.

![Picture36](https://github.com/mars0426/Azure-Labs/assets/42570850/d559e826-d570-4813-addf-0109312a46b7)

10. In the **Feature Rules** dialog box, verify that all the rules have
    passed. If the rules returned a few warnings, make sure you fix them
    before proceeding with the installation. Click **Next**.

![Picture37](https://github.com/mars0426/Azure-Labs/assets/42570850/37edee0c-81f9-4a90-b2ee-e7ba3846a46b)

11. In the **Instance Configuration** dialog box, provide a value for
    the SQL Server Network Name. Click **Next**.

![Picture38](https://github.com/mars0426/Azure-Labs/assets/42570850/4c1e3198-6e67-41f6-8970-9bcf16ed343a)

12. In the **Cluster Resource Group** dialog box, check the resources
    available on your WSFC. This tells you that a new Resource Group
    will be created on your WSFC for the SQL Server FCI. To specify the
    SQL Server cluster resource group name, you can either use the
    drop-down box to specify an existing group to use or type the name
    of a new group to create it. Click **Next**.

![Picture39](https://github.com/mars0426/Azure-Labs/assets/42570850/0ae00e77-002a-4610-9dde-7e0cd02a0bac)

13. In the **Cluster Disk Selection** dialog box, select the available
    disk groups that are on the WSFC for the SQL Server FCI to use.
    Click **Next**.

![Picture40](https://github.com/mars0426/Azure-Labs/assets/42570850/204132b7-2fc5-4fd5-be29-6d8bff19b2d7)

14. In the **Cluster Network Configuration** dialog box, enter the IP
    address and subnet mask values that your SQL Server FCI will use.
    Select the **IPv4** checkbox under the **IP Type** column as you
    will be using a static IP address. Click **Next**.

![Picture41](https://github.com/mars0426/Azure-Labs/assets/42570850/74db8ec2-1475-41e8-878d-9eb44e4427c6)

15. In the **Server Configuration** dialog box, provide the credentials
    for the SQL Server service accounts in the **Service Accounts** tab.
    Make sure that both the SQL Server Agent and SQL Server Database
    Engine services have a **Startup Type** of Manual. The WSFC will
    take care of stopping and starting these services. Select the
    checkbox **Grant Perform Volume Maintenance Task** privilege to SQL
    Server Database Engine Service. Click **Next**.

![Picture42](https://github.com/mars0426/Azure-Labs/assets/42570850/db984aeb-33dd-4982-a35e-7498586caae6)

16. In the **Database Engine Configuration** dialog box, under the
    **Server Configuration** tab,

Select **Windows authentication mode** in the **Authentication Mode**
section. If required, you can change it later after the installation is
complete.

Add the currently logged on user to be a part of the SQL Server
administrators group by clicking the **Add Current User** button in the
**Specify SQL Server Administrators** section. You can also add Active
Directory domain accounts or security groups as necessary.

![Picture43](https://github.com/mars0426/Azure-Labs/assets/42570850/6c930cb6-d185-4f9d-9d3d-d5d2961697be)

17. In the **Data Directories** tab, specify the location of the data
    files, the log files, and the backup files. Click **Next**.

![Picture44](https://github.com/mars0426/Azure-Labs/assets/42570850/d3d551a8-1971-46d5-8ab4-37e8dcb3327a)

18. In the **Feature Configuration Rules** dialog box, verify that all
    checks are successful. Click **Next**.

![Picture45](https://github.com/mars0426/Azure-Labs/assets/42570850/e7206dd3-6368-42a0-877b-449945204d8a)

19. In the **Ready to Install** dialog box, verify that all
    configuration settings are correct. Click **Install** to proceed
    with the installation.

![Picture46](https://github.com/mars0426/Azure-Labs/assets/42570850/7b5c8182-b27c-4d08-b003-113c6f36ae4e)

20. In the **Complete** dialog box, click **Close**. This concludes the
    installation of a SQL Server 2019 FCI.

![Picture47](https://github.com/mars0426/Azure-Labs/assets/42570850/b05a7f8b-62e3-4b01-9fe3-6e7e969813e7)

# Step 10. Install Secondary (Failover) Cluster Node

1.  Connect to the second SQL Server VM.

2.  Run setup.exe from the SQL Server 2019 installation media to launch
    **SQL Server Installation Center**. Click on the **Installation**
    link on the left-hand side.

3.  Click the **Add node to a SQL Server failover cluster** link. This
    will run the SQL Server 2019 Setup wizard.

![Picture48](https://github.com/mars0426/Azure-Labs/assets/42570850/9fde5912-61f6-4142-bdb1-fbb6fd816750)

4.  In the **Product Key** dialog box, enter the product key that came
    with your installation media and click **Next**.

![Picture49](https://github.com/mars0426/Azure-Labs/assets/42570850/726ba2b7-81fc-4a42-a7b6-1aa4b90442ff)

5.  In the **License Terms** dialog box, click the **I accept the
    license terms** check box and click **Next**.

![Picture50](https://github.com/mars0426/Azure-Labs/assets/42570850/e84463f0-a928-4556-855f-b7075f6522ca)

6.  In the **Global Rules** dialog box, validate that the checks return
    successful results and click **Next**.

![Picture51](https://github.com/mars0426/Azure-Labs/assets/42570850/591f95be-f5dd-41af-b769-72aa4001a87c)

7.  In the **Microsoft Update** dialog box, click **Next**.

![Picture52](https://github.com/mars0426/Azure-Labs/assets/42570850/45187fde-ed55-4a73-bf92-a227f680da46)

8.  In the **Add Node Rules** dialog box, validate that the checks
    return successful results. Click **Next**.

![Picture35](https://github.com/mars0426/Azure-Labs/assets/42570850/ad2a5161-57d9-483d-8003-f728b603445d)


9.  In the **Cluster Node Configuration** dialog box, validate that the
    information for the existing SQL Server 2019 FCI that you installed
    and configured in Step 6 is correct. Click **Next**.

![Picture53](https://github.com/mars0426/Azure-Labs/assets/42570850/07c497bd-14fd-4e89-98ec-ce92fc65879e)

10. In the **Cluster Network Configuration** dialog box, validate that
    the IP address information is the same as the one you provided in
    Step 6. Click **Next**.

![Picture54](https://github.com/mars0426/Azure-Labs/assets/42570850/a2ebf3a0-5c1b-4fb8-910e-d255d62802e3)

11. In the **Service Accounts** dialog box, verify that the information
    is the same as what was used to configure the first node. Provide
    the appropriate credentials for the corresponding SQL Server service
    accounts. Select the **Grant Perform Volume Maintenance Task
    privilege to SQL Server Database Engine Service** checkbox.
    **Click** Next.

![Picture55](https://github.com/mars0426/Azure-Labs/assets/42570850/825d3c77-1ff4-49d8-aa5b-a6f52638a88d)

12. In the **Feature Rules** dialog box, verify that all checks are
    successful. Click **Next**.

![Picture56](https://github.com/mars0426/Azure-Labs/assets/42570850/607f8dea-416d-493b-b82d-42ad6eed1d03)

13. In the **Ready to Add Node** dialog box, verify that all
    configuration settings are correct. Click **Install** to proceed
    with the installation.

![Picture57](https://github.com/mars0426/Azure-Labs/assets/42570850/e5178802-f704-41ef-bef3-f3cb3d3ed8ca)

14. In the **Complete** dialog box, click **Close**. This concludes
    adding a node to an existing SQL Server 2017 FCI.

![Picture58](https://github.com/mars0426/Azure-Labs/assets/42570850/26e896bb-50ee-4f67-a10c-247dc6d3d45c)

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
