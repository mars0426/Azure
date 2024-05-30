# Contents {#contents .TOC-Heading}

[Purpose [1](#purpose)](#purpose)

[Prerequisites [1](#prerequisites)](#prerequisites)

[Steps [1](#steps)](#steps)

[Related Information [1](#related-information)](#related-information)

# Purpose

This document provides instructions for converting a physical computer
into a virtual machine using VMware vCenter Converter. VMware vCenter
Converter is a free program that can be installed on your physical
computer running Windows. Converter copies the data on your hard drive
into a virtual disk file (.vmdk), which can then be used in migrating to
Viettel Cloud or AWS.

# Prerequisites

1.  Ensure that you have an external hard drive or a SMB network share
    location that has enough free space to store the new virtual disk
    (.vmdk).

2.  Confirm that the firewall on your virtual machine is not blocking
    Internet access.

3.  On your physical computer, download VMware vCenter Converter
    Standalone from the [VMware Download
    Center](https://customerconnect.vmware.com/downloads/info?slug=infrastructure_operations_management/vmware_vcenter_converter_standalone/5_5).
    Double-click the installer file to start the installation. Select
    your language. Select the default installation options. On the Setup
    Type screen, select **Local installation**.

# Steps

1.  Start vCenter Converter.

2.  Go to **File** \> **New** \> **Convert Machine**.

3.  From the **Select source type** menu, select **Powered-on machine**.

4.  Under **Specify the powered-on machine**, select **This local
    machine** and click **Next**.

5.  From the **Select destination type** dropdown menu, select **VMware
    Workstation or other VMware virtual machine**.

6.  From the **Select VMware product** dropdown menu, select the VMware
    product you want to use to run the virtual machine.

**Note**: If the current version is not available, please select the
previous available version. The virtual machine can be upgraded to the
latest version in the VMware Product which you are using.

7.  Click **Browse** and navigate to the connected external hard drive
    or SMB network share. Choose a location on that drive to save the
    files and click **OK**.

8.  If you want, change the name of the virtual machine by editing the
    [Name]{.mark} field under [Virtual machine details]{.mark}.

9.  Click **Next**.

10. (Optional) Click the **Edit** button beside **Data to copy** to make
    adjustments to the partitions you will import. If your computer only
    has one partition, or if you want to convert the entire disk, skip
    this step.

**Note**: If there are more than one partitions listed, choose the C:
drive as the main partition to convert.

11. Deselect the partitions that you do not want to convert.

**Note**: If your physical machine has a recovery partition, deselect
this partition.

12. Click **Next**.

13. Click **Finish** to start the conversion.

# Related Information

1.  [Converting a physical machine into a virtual machine using
    Converter
    Standalone](https://youtu.be/M2vSRXZBlFU?si=he9TcSZFZZeq6BSD)
    (YouTube)
