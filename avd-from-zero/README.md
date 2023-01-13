# 從零開始創建 AVD 環境
本文透過實際演練，示範如何從零開始創建一整套 AVD (Azure Virtual Desktop) 環境。
## 架構
(待補)
## Lab1 - 建立黃金映像 (Golden Image)
1. 建立 Resource group，Resource group name 輸入「AVD-PoC」，Region 選擇「Japan East」
2. 建立 Virtual machine，Resource group 選擇「AVD-PoC」，Virtual machine name 輸入「Golden-Image」，Region 選擇「Japan East」，Image 選擇「Windows 10 Enterprise multi-session, version 21H2 + Microsoft 365 Apps」
    ![image](https://user-images.githubusercontent.com/42570850/212196092-63c30c52-49cd-4e41-be5b-89cac9529664.png)
3. 安裝 language packs
  * 遠端登入 Golden-Image，開啟 Edge 下載 [language packs](https://learn.microsoft.com/en-us/azure/virtual-desktop/language-packs)
    ![image](https://user-images.githubusercontent.com/42570850/212198451-01f0f8e2-42ac-4b55-a608-31f3fe30e3ab.png)
  * 依序掛載 Language ISO 與 FOD Disk 1 ISO
  * 以常用的繁體中文、簡體中文及日文為例，開啟 PowerShell 執行以下指令（參考[Dino9021 的部落格](https://blog.dino9021.com/2021/01/azure-windows-10-multi-session-language.html)）
  ```powershell
  $LanguageISODrive = 'F:';
  $FODDiskISO = 'G:';

  ##Chinese(zh-TW)##

  Add-AppProvisionedPackage -Online -PackagePath $LanguageISODrive\LocalExperiencePack\zh-tw\LanguageExperiencePack.zh-TW.Neutral.appx -LicensePath $LanguageISODrive\LocalExperiencePack\zh-tw\License.xml
  Add-WindowsPackage -Online -PackagePath $LanguageISODrive\x64\langpacks\Microsoft-Windows-Client-Language-Pack_x64_zh-tw.cab

  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Basic-zh-tw-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Fonts-Hant-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Handwriting-zh-tw-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-OCR-zh-tw-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Speech-zh-tw-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-TextToSpeech-zh-tw-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-InternationalFeatures-Taiwan-Package~31bf3856ad364e35~amd64~~.cab

  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~zh-TW~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~zh-TW~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~zh-TW~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~zh-TW~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~zh-TW~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~zh-TW~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~zh-TW~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~zh-TW~.cab

  $LanguageList = Get-WinUserLanguageList
  $LanguageList.Add("zh-TW")
  Set-WinUserLanguageList $LanguageList -force



  ##Chinese(zh-CN)##

  Add-AppProvisionedPackage -Online -PackagePath $LanguageISODrive\LocalExperiencePack\zh-cn\LanguageExperiencePack.zh-CN.Neutral.appx -LicensePath $LanguageISODrive\LocalExperiencePack\zh-cn\License.xml
  Add-WindowsPackage -Online -PackagePath $LanguageISODrive\x64\langpacks\Microsoft-Windows-Client-Language-Pack_x64_zh-cn.cab

  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Basic-zh-cn-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Fonts-Hans-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Handwriting-zh-cn-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-OCR-zh-cn-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Speech-zh-cn-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-TextToSpeech-zh-cn-Package~31bf3856ad364e35~amd64~~.cab

  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~zh-CN~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~zh-CN~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~zh-CN~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~zh-CN~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~zh-CN~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~zh-CN~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~zh-CN~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~zh-CN~.cab

  $LanguageList = Get-WinUserLanguageList
  $LanguageList.Add("zh-CN")
  Set-WinUserLanguageList $LanguageList -force



  ##Japan(ja-JP)##

  Add-AppProvisionedPackage -Online -PackagePath $LanguageISODrive\LocalExperiencePack\ja-jp\LanguageExperiencePack.ja-JP.Neutral.appx -LicensePath $LanguageISODrive\LocalExperiencePack\ja-jp\License.xml
  Add-WindowsPackage -Online -PackagePath $LanguageISODrive\x64\langpacks\Microsoft-Windows-Client-Language-Pack_x64_ja-jp.cab

  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Basic-ja-jp-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Fonts-Jpan-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Handwriting-ja-jp-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-OCR-ja-jp-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-Speech-ja-jp-Package~31bf3856ad364e35~amd64~~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-LanguageFeatures-TextToSpeech-ja-jp-Package~31bf3856ad364e35~amd64~~.cab

  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~ja-JP~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~ja-JP~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~ja-JP~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~ja-JP~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~ja-JP~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~ja-JP~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~ja-JP~.cab
  Add-WindowsPackage -Online -PackagePath $FODDiskISO\Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~ja-JP~.cab

  $LanguageList = Get-WinUserLanguageList
  $LanguageList.Add("ja-JP")
  Set-WinUserLanguageList $LanguageList -force
  
  ```
  * 開啟 Settings → Time & Language → Language，確認 language packs 安裝完成
    ![image](https://user-images.githubusercontent.com/42570850/212203394-8586b923-1da1-4054-9715-96a21098301b.png)

  * 卸載 Language ISO 與 FOD Disk 1 ISO，並刪除這兩個 ISO 檔
4. 依實際需求，安裝 LOB (Line of Business) 應用程式及輸入法，例如 Acrobat Reader、Photoshop、AutoCAD 等
5. 執行 Windows update，確認無任何更新需要安裝
    ![image](https://user-images.githubusercontent.com/42570850/212209305-a019a1da-20aa-4aca-bf7c-06dacb7ce585.png)

6. 執行 Command Prompt，輸入下列指令，執行 Sysprep，執行完成後會自動關機
    ```
    %WINDIR%\system32\sysprep\sysprep.exe /generalize /shutdown /oobe /mode:vm
    ```
7. 到 Azure Portal，進入 Golden-Image 頁面，點選「Stop」，確認 Status 變成「Stopped (deallocated)」
    ![image](https://user-images.githubusercontent.com/42570850/212209576-bc1ebc9a-1e44-4f07-924a-74e6e2f4e4ac.png)
8. 點選「Capture」，Share image to Azure compute gallery 選擇「No, capture only a managed image.」，勾選「Automatically delete this virtual machine after creating the image」，Name 輸入「Golden-Image-AS」，點選「Review + create」→「Create」
    ![image](https://user-images.githubusercontent.com/42570850/212210347-2190b240-389c-4ef1-b117-026f4d367bd4.png)
9. 將資源群組 AVD-PoC 中除了 Golden-Image-AS 之外的其他資源刪除，只保留 Golden-Image-AS
## Lab2 - 建立虛擬網路
1. 建立 Virtual network，Resource group 選擇「AVD-PoC」，Name 輸入「Hub-VNet」，Region 選擇「Japan East」，IPv4 address space 輸入「10.0.0.0/16」，並新增一個 Subnet，Subnet name 輸入「AD-Subnet」，Subnet address range 輸入「10.0.0.0/24」
2. 建立 Virtual network，Resource group 選擇「AVD-PoC」，Name 輸入「Spoke-VNet」，Region 選擇「Japan East」，IPv4 address space 輸入「10.1.0.0/16」，並新增一個 Subnet，Subnet name 輸入「AVD-Subnet」，Subnet address range 輸入「10.1.0.0/24」
3. 建立 Virtual network peering，進入 Hub-VNet，在左列功能選單點選「Peerings」，點選「Add」，Peering link name (This virtual network) 輸入「Hub-to-Spoke」，Peering link name (Remote virtual network) 輸入「Spoke-to-Hub」，Virtual Network 選擇「Spoke-VNet」，然後點選「Add」

    ![image](https://user-images.githubusercontent.com/42570850/212268586-cb85f45c-ea4b-4b3d-8942-954ed40d4336.png)

## Lab3 - 建立 Active Directory Domain Controller，並同步到 Azure Active Directory
1. 在 Azure Active Directory 新增 custom domain，本文以「chtdnadmin.tw」為例，步驟請參考 <https://learn.microsoft.com/zh-tw/azure/active-directory/fundamentals/add-custom-domain>
2. 建立 Virtual machine，Resource group 選擇「AVD-PoC」，Virtual machine name 輸入「AD-Controller」，Region 選擇「Japan East」，Image 選擇「Windows Server 2016 Datacenter」，並將其放在 Hub-VNet 中的 AD-Subnet
3. 登入 AD-Controller，新增 Active Directory Domain Services 角色及管理工具，並新建一個新的 forest

    ![image](https://user-images.githubusercontent.com/42570850/212277947-c14b46d8-aa11-4e9d-983f-dcad3d03c2e3.png)

4. 確認 AD-Controller 的內網 IP（如無意外應是 10.0.0.4），並更新 Hub-VNet 的 DNS 資料

    ![image](https://user-images.githubusercontent.com/42570850/212280613-005fdb0c-664a-40e2-8f89-37b7c6f55620.png)

5. 登入 AD-Controller，新增一個名稱為 avduser1 的使用者

    ![image](https://user-images.githubusercontent.com/42570850/212281466-4a09b748-d53a-4c1c-bc11-f08c62c41261.png)

6. 同步 Active Directory 到 Azure Active Directory
    * 下載 [Azure AD Connect](https://www.microsoft.com/en-us/download/details.aspx?id=47594)，使用 express settings 模式進行安裝

    ![image](https://user-images.githubusercontent.com/42570850/212283032-c388b171-a75a-41a2-9f68-3933743f72ff.png)

    * 輸入 Azure AD 帳號密碼

    ![image](https://user-images.githubusercontent.com/42570850/212284248-cc69b22c-9873-4940-af7c-1083ea082f78.png)

    * 輸入 Active Directory 帳號密碼

    ![image](https://user-images.githubusercontent.com/42570850/212284581-82e57917-0022-4280-b997-bcb167bca8ed.png)

    * 點選「Install」開始安裝

    ![image](https://user-images.githubusercontent.com/42570850/212284842-df490162-0675-4ab6-862b-aa37762a0bcb.png)

    * 安裝完成後稍候片刻，確認 AD 使用者同步至 Azure AD。如果尚未同步，可執行下列 PowerShell 指令
    ```powershell
    Start-ADSyncSyncCycle -PolicyType Delta
    ```
    ![image](https://user-images.githubusercontent.com/42570850/212291566-a2a5e2b2-a751-460f-a74a-909271e8ca5c.png)

## Lab4 - 設定 FSLogix
1. 由於本文是以集區 (Pool) 的形態建立工作階段主機，因此需要 Azure Files 來集中存放 FSLogix 的 User profile
2. 新增 Storage Accounts，Resource group 選擇「AVD-PoC」，Storage account name 輸入「storageforfslogix」，Region 選擇「Japan East」，Redundancy 選擇「LRS」

![image](https://user-images.githubusercontent.com/42570850/212294533-fd9b98d3-32b0-4250-b18b-1a73661755b3.png)

3. 進入 storageforfslogix，在左列功能選單點選「File shares」，點選「＋File share」，Name 輸入「fslogix」，Tier 選擇「Hot」，點選「Create」

![image](https://user-images.githubusercontent.com/42570850/212296131-22852163-9d7e-4f35-be07-9284ea9898fb.png)

4. 為 Azure Files 啟用 AD 驗證功能
* 登入 AD-Controller，參考[微軟文件](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-identity-ad-ds-enable#option-one-recommended-use-azfileshybrid-powershell-module) ，下載[AzFilesHybrid module](https://github.com/Azure-Samples/azure-files-samples/releases)，解壓縮後放在 C:\ 目錄下
* 開啟 PowerShell，依序執行下列指令
```powershell
# Change the execution policy to unblock importing AzFilesHybrid.psm1 module
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
```
```powershell
# Navigate to where AzFilesHybrid is unzipped and stored and run to copy the files into your path
cd C:\AzFilesHybrid\
.\CopyToPSPath.ps1 
```
```powershell
# Import AzFilesHybrid module
# 第一次執行時，依提示關閉 PowerShell，再打開後才能執行
Import-Module -Name AzFilesHybrid
```

```powershell
Install-Module Az
Import-Module Az
```

```powershell
# Login with an Azure AD credential that has either storage account owner or contributor Azure role 
# assignment. If you are logging into an Azure environment other than Public (ex. AzureUSGovernment) 
# you will need to specify that.
# See https://learn.microsoft.com/azure/azure-government/documentation-government-get-started-connect-with-ps
# for more information.
Connect-AzAccount
```
```powershell
# Define parameters
# $StorageAccountName is the name of an existing storage account that you want to join to AD
# $SamAccountName is the name of the to-be-created AD object, which is used by AD as the logon name 
# for the object. It must be 20 characters or less and has certain character restrictions. 
# See https://learn.microsoft.com/windows/win32/adschema/a-samaccountname for more information.
# 把下面的 <your-subscription-id-here> 換成您的 Subscription ID
$SubscriptionId = "<your-subscription-id-here>"
$ResourceGroupName = "AVD-PoC"
$StorageAccountName = "storageforfslogix"
```
```powershell
# Select the target subscription for the current session
Select-AzSubscription -SubscriptionId $SubscriptionId 
```
```powershell
# Register the target storage account with your active directory environment under the target OU 
# (for example: specify the OU with Name as "UserAccounts" or DistinguishedName as 
# "OU=UserAccounts,DC=CONTOSO,DC=COM"). You can use this PowerShell cmdlet: Get-ADOrganizationalUnit 
# to find the Name and DistinguishedName of your target OU. If you are using the OU Name, specify it 
# with -OrganizationalUnitName as shown below. If you are using the OU DistinguishedName, you can set it 
# with -OrganizationalUnitDistinguishedName. You can choose to provide one of the two names to specify 
# the target OU. You can choose to create the identity that represents the storage account as either a 
# Service Logon Account or Computer Account (default parameter value), depending on your AD permissions 
# and preference. Run Get-Help Join-AzStorageAccountForAuth for more details on this cmdlet.

Join-AzStorageAccountForAuth `
        -ResourceGroupName $ResourceGroupName `
        -StorageAccountName $StorageAccountName `
```
* 完成後，確認 Azure Files 已啟用 AD 驗證功能

    ![image](https://user-images.githubusercontent.com/42570850/212310915-14d0b2ea-c7e7-43bd-bf74-0aa8eac4d39b.png)

5. 設定 Azure Files 權限
* 進入 storageforfslogix，在左方工具列點選「Access Control (IAM)」，點選「Add」→「Add role assignment」

![image](https://user-images.githubusercontent.com/42570850/212318395-537e713d-9b19-4777-aad1-ecec1c61cc21.png)

* Role 選擇「Storage File Data SMB Share Contributor」，Members 增加「avduser1」，點選「Review + Assign」

![image](https://user-images.githubusercontent.com/42570850/212318851-9e962cfc-bfde-4b72-a783-539579227b67.png)

6.  設定 Azure Files 的 NTFS 權限
* 進入 fslogix，點選「Connect」

![image](https://user-images.githubusercontent.com/42570850/212319700-3640186f-826e-4840-bb6a-012ecc8bdbfa.png)

* 選擇「Storage account key」，點選「Show Script」，複製這段 Script

![image](https://user-images.githubusercontent.com/42570850/212319981-9682a56c-182b-4c9c-b492-287bed0ff73c.png)

* 登入 AD-Controller，開啟 PowerShell，執行這段 Script，完成後可看到磁碟已掛載

![image](https://user-images.githubusercontent.com/42570850/212320578-8a30768b-090e-437e-9336-3d97673e341d.png)

* 給予 AVD 使用者 Full Control 的 NTFS 權限

![image](https://user-images.githubusercontent.com/42570850/212321119-2e8952fe-41fb-41e6-b7a5-58b860c7111d.png)

7. 設定 Group Policy
* 參考[微軟文件](https://learn.microsoft.com/en-us/fslogix/use-group-policy-templates-ht)，下載 [FSLogix](https://aka.ms/fslogix_download)，解壓縮後放到 C:\ 目錄下
* 複製資料夾中的 fslogix.admx 到 C:\Windows\SYSVOL\sysvol\chtdnadmin.tw\Policies\PolicyDefinitions\ 目錄下（把 chtdnadmin.tw 換成您的 domain name，如果沒有 PolicyDefinitions 目錄就新建一個）

![image](https://user-images.githubusercontent.com/42570850/212324971-45d009c0-160f-46e7-a118-8f01bce9c4c0.png)

* 複製資料夾中的 fslogix.adml 到 C:\Windows\SYSVOL\sysvol\chtdnadmin.tw\Policies\PolicyDefinitions\en-US\ 目錄下
* 在 Active Directory Users and Computers 裡新增一個 Organizational Unit，命名為 AVDPooled

![image](https://user-images.githubusercontent.com/42570850/212326197-dd9dafdb-28d0-4e6e-b57a-7ccf3fb174d6.png)

* 開啟 Group Policy Management，為 AVDPooled 新增一個 GPO，同樣命名為 AVDPooled

![image](https://user-images.githubusercontent.com/42570850/212327917-5daed44c-9e14-4fca-af3a-e376d9df33c6.png)

* 在 AVDPooled 按右鍵點選「Edit」，Computer Configuration > Polocies > Administrative Templates > FSLogix > Profile containers，設定如下
    * Enabled: Enabed
    * Outlook Cached Mode: Enabled
    * Delete Local Profile Whe VHD Should Apply: Enabled
    * VHD Locations: \\storageforfslogix.file.core.windows.net\fslogix
![image](https://user-images.githubusercontent.com/42570850/212329916-e0c3ae44-92bb-48eb-8300-247fffb6c458.png)

* 接著到 Computer Configuration > Polocies > Administrative Templates > FSLogix > Profile containers > Container and Directory Naming，設定如下
    * Volume Type (VHD or VHDX): VHDX
    * Flip Flop Profile Directory Name: Enabled

![image](https://user-images.githubusercontent.com/42570850/212331640-94c0f431-7bcb-4392-a012-f2b04e140dce.png)

## Lab5 - 建立 Host pool
1. 將 Spoke-VNet 的 DNS Server 設成 10.0.0.4
2. 建立 Host pool
* Resource group 選擇「AVD-PoC」，Host pool name 輸入「Host-Pooled」，Host pool type 選擇「Pooled」，Load balancing algorithm 選擇「Depth-first」，Max session limit 輸入「10」，點選「Next: Virtual Machines」

![image](https://user-images.githubusercontent.com/42570850/212336899-c2f68161-0e4b-4e8b-a1c6-a3c4ad9f02ed.png)

* Add Azure virtual machines 選擇「Yes」，Resource group 選擇「AVD-PoC」，Name prefix 輸入「Host-Pooled」，Virtual machine locaion 選擇「Japan East」，Availability options 選擇「No infrastructure redundancy required」，Image 點選「See all images」，從 My item 選擇「Golden-Image-AS」，Number of VMs 輸入「1」，Boot Diagnostics 選擇「Disable」，Virtual network 選擇「Spoke-VNet」，Subnet 選擇「AVD-Subnet」，Domain to join 選擇 Active Directory，輸入相關帳號密碼後，點選「Next: Workspace」

![image](https://user-images.githubusercontent.com/42570850/212338961-db6ecf52-6126-42ff-9916-6f3c5615d989.png)

* Register desktop add group 選擇「Yes」，點選「Create new」，Workspace name 輸入「Workspace-Pooled」，點選「OK」，接著點選「Review + create」→「Create」

![image](https://user-images.githubusercontent.com/42570850/212339838-722dfbfb-b101-4074-9215-274a5929c1a1.png)

* 建立完成後，進入 Host-Pooled，在左方工具列點選「Session hosts」可看到 host 狀態為 Available

![image](https://user-images.githubusercontent.com/42570850/212344527-450194b3-65eb-4864-94e3-80c95e78793f.png)

* 在左方工具列點選「RDP Proterties」，點選「Device direction」，依下圖進行設定後點選「Save」

![image](https://user-images.githubusercontent.com/42570850/212345395-48b40b7a-0094-42cd-9e59-1d0a8f7e8fed.png)

* 在左方工具列點選「Application groups」，點選「Host-Pooled-DAG」，點選「Assignments」，點選「Add」，選取「avduser1」

![image](https://user-images.githubusercontent.com/42570850/212346117-0a10ebb6-f114-4517-803d-c21fd46ca721.png)

3. 下載並安裝 [Remote Destop client](https://go.microsoft.com/fwlink/?linkid=2068602)

4. 點選「訂閱」，輸入帳號 avduser1@chtdnadmin.tw 及密碼，認證成功後可看到 Workspace-Pooled 的內容

![image](https://user-images.githubusercontent.com/42570850/212348393-69c8e7a8-80d9-4d1e-be33-f2dee355aadd.png)

5. 雙擊「SessionDesktop」進行 AD 認證，可勾選「記住我」，下點進入便不用再輸入密碼

![image](https://user-images.githubusercontent.com/42570850/212350212-a3cf7fd6-b5c3-41f9-a7ad-e98b3fd08245.png)

6. 建立 Application group
* 新建 Application group，Resource group 選擇「AVD-PoC」，Host pool 選擇「Host-Pooled」，Application group name 輸入「Host-Pooled-AppAG」，點選「Next: Applications」

![image](https://user-images.githubusercontent.com/42570850/212351627-6c2fb433-3f0b-482a-bc1a-50c3c60f8071.png)

* 點選「Add applications」，Application 選擇「PowerPoint」，Display name 輸入「PowerPoint」，點選「Save」，點選「Next: Assignments」

![image](https://user-images.githubusercontent.com/42570850/212352245-bc872647-4169-43c8-bb41-5817d91414a9.png)

* 點選「Add Azure AD users or user groups」，選取「avduser1」，點選「Next: Workspace」

![image](https://user-images.githubusercontent.com/42570850/212352733-a997d8e7-b91b-4af9-b9e0-061e7d805ce3.png)

* Register application group 選擇「Yes」，點選「Review + create」→「Create」

![image](https://user-images.githubusercontent.com/42570850/212353028-8f508234-a92f-4b30-96c1-4b14d7700375.png)


