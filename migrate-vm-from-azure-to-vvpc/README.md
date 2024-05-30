# Contents {#contents .TOC-Heading}

[Migrate Azure Virtual Machine to Viettel VPC
[1](#migrate-azure-virtual-machine-to-viettel-vpc)](#migrate-azure-virtual-machine-to-viettel-vpc)

[Assessment of the Azure VM
[1](#assessment-of-the-azure-vm)](#assessment-of-the-azure-vm)

[Copy the VHD files [3](#copy-the-vhd-files)](#copy-the-vhd-files)

[Replicate Data from Azure Blob Storage to Viettel S3
[4](#replicate-data-from-azure-blob-storage-to-viettel-s3)](#replicate-data-from-azure-blob-storage-to-viettel-s3)

[Download and install rclone
[4](#download-and-install-rclone)](#download-and-install-rclone)

[Use "rclone copy" command to copy files
[4](#use-rclone-copy-command-to-copy-files)](#use-rclone-copy-command-to-copy-files)

# Migrate Azure Virtual Machine to Viettel VPC

## Assessment of the Azure VM

1.  The first step is to determine how many VMs need to be migrated. If
    you have organized your environment using Resource Groups, then for
    you this step is a piece of cake. List the Resource Group and all
    VMs in use will be listed. From the list below we see that we need
    to migrate five VMs over.

![A screenshot of a computer Description automatically
generated](media/image1.png){width="7.5in" height="5.782638888888889in"}

2.  The second step is to stop all the VMs that will be migrated. This
    will bring the service down. To do that, just click on the desired
    VM, and on the new blade click on **Stop** and then **Yes**.

![A screenshot of a computer Description automatically
generated](media/image2.png){width="7.5in" height="3.071527777777778in"}

3.  The third step is to document the current utilization of memory and
    CPU. This can be accomplished by clicking on the desired VM and then
    clicking on **Overview**. On the new blade that is displayed on the
    right side, we will have the Size, which gives us that information.

![A screenshot of a computer Description automatically
generated](media/image3.png){width="7.5in"
height="3.2354166666666666in"}

4.  The final step of the assessment is to identify the disk names. This
    can be done by clicking on **Disks**. On the new blade, a list of
    the OS Disk and Data Disks that are in use by the current VM will be
    listed. We will click on each entry on the left and we will copy the
    disk name listed on the blade on the right side. (There is a copy
    button available when you select the field.)

![A screenshot of a computer Description automatically
generated](media/image4.png){width="7.5in"
height="2.8222222222222224in"}

The results of the current assessment should be a table like the one
below, where we have all the information required to create the new VM
on Viettel VPC and associate the correct disks to them.

![A close-up of a computer Description automatically
generated](media/image5.png){width="7.260416666666667in"
height="1.8958333333333333in"}

## Copy the VHD files

1.  Download and install the Microsoft Azure Storage Explorer utility.
    (You can use this
    [link](https://azure.microsoft.com/en-us/products/storage/storage-explorer/)
    to download it, and it can be used on Windows, Mac and Linux.) The
    installation process is simple and does not require any additional
    configuration. Just use the default values.

2.  After opening the Microsoft Azure Storage Explorer, click on the
    second icon to configure an account. This process will create
    authentication with the Azure service. After it is authenticated, a
    list of all storage objects will be seen on the left side. Expand
    the ones related to the VMs to be transitioned, then expand **Blog
    Containers**, and then **vhds**. Select each VHD listed on the right
    side and click **Download**.

![A screenshot of a computer Description automatically
generated](media/image6.png){width="7.5in"
height="1.8916666666666666in"}

Each download will be listed on the bottom right side with its
respective progress on the copy process. Wait to get all of them
completed before moving forward to the next phase of the transition.

![A screenshot of a computer program Description automatically
generated](media/image7.png){width="7.5in" height="2.053472222222222in"}

# Replicate Data from Azure Blob Storage to Viettel S3

## Download and install rclone

1.  Rclone is a Go program and comes as a single binary file.
    [Download](https://rclone.org/downloads/) the relevant binary and
    extract the rclone executable, rclone.exe on Windows, from the
    archive.

2.  Run **rclone.exe config** to setup. See [rclone config
    docs](https://rclone.org/docs/) for more details.

3.  Optionally configure [automatic
    execution](https://rclone.org/install/#autostart).

## Use "rclone copy" command to copy files

1.  Rclone is a Go program and comes as a single binary file.
    [Download](https://rclone.org/downloads/) the relevant binary and
    extract the rclone executable, rclone.exe on Windows, from the
    archive.

2.  Go to your Azure Account and run the following command in the Azure
    Cloud Shell. Change the scope of the command by replacing the
    placeholders with your actual Subscription ID, Resource Group Name,
    and Storage Account Name:

+-----------------------------------------------------------------------+
| \`\`\`bash                                                            |
|                                                                       |
| az ad sp create-for-rbac \--name Viettel-Rclone-Reader \--role        |
| \"Storage Blob Data Reader\" \--scopes /subscriptions/{Subscription   |
| ID}/resourceGroups/{Resource Group                                    |
| Name}/providers/Microsoft.Storage/storageAccounts/{Storage Account    |
| Name}                                                                 |
|                                                                       |
| \`\`\`                                                                |
+=======================================================================+
+-----------------------------------------------------------------------+

After running the command, you will receive credentials like the
following:

+-----------------------------------------------------------------------+
| \`\`\`json                                                            |
|                                                                       |
| {                                                                     |
|                                                                       |
| \"appId\": \"dffc217a-c2af-41b8-b120-f8819d8999a4\",                  |
|                                                                       |
| \"displayName\": \"Viettel-Rclone-Reader\",                           |
|                                                                       |
| \"password\": \"B2E8Q\~dAch55gCB5Rr4JafA.dcQwmfHbXW571ctI\",          |
|                                                                       |
| \"tenant\": \"ee873d89-a26e-47cf-8019-b65d6ee4d46c\"                  |
|                                                                       |
| }                                                                     |
|                                                                       |
| \`\`\`                                                                |
+=======================================================================+
+-----------------------------------------------------------------------+

Copy these credentials as they will be needed later.

3.  Go to your home directory and create a file named
    "azure-principal.json". Paste the Azure credentials received in Step
    2 into this file.

4.  Create a file named "rclone.conf" in the "\~/.config/rclone/"
    directory. Paste the following commands into the file, replacing
    \"AZStorageAccount\" with your desired name for the Azure storage
    account:

+-----------------------------------------------------------------------+
| \`\`\`ini                                                             |
|                                                                       |
| \[AZStorageAccount\]                                                  |
|                                                                       |
| type = azureblob                                                      |
|                                                                       |
| account = dcmpod2                                                     |
|                                                                       |
| service_principal_file = azure-principal.json                         |
|                                                                       |
| \[s3\]                                                                |
|                                                                       |
| type = s3                                                             |
|                                                                       |
| provider = Viettel                                                    |
|                                                                       |
| env_auth = true                                                       |
|                                                                       |
| \`\`\`                                                                |
+=======================================================================+
+-----------------------------------------------------------------------+

5.  Copy the data from the Azure storage account to the Viettel S3
    bucket using the following command:

+-----------------------------------------------------------------------+
| \`\`\`bash                                                            |
|                                                                       |
| rclone copy AZStorageAccount:data-disk s3:data-disk                   |
|                                                                       |
| \`\`\`                                                                |
+=======================================================================+
+-----------------------------------------------------------------------+

6.  Check the files in the Viettel S3 bucket to ensure that the data has
    been successfully migrated.

7.  If any files are missing, use the sync command to ensure that the
    data in the destination matches the source:

+-----------------------------------------------------------------------+
| \`\`\`bash                                                            |
|                                                                       |
| rclone sync AZStorageAccount:blob-container s3:examplebucket-01       |
|                                                                       |
| \`\`\`                                                                |
+=======================================================================+
+-----------------------------------------------------------------------+
