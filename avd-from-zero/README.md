# 從零開始創建 AVD 環境
本文透過實際演練，示範如何從零開始創建一整套 AVD (Azure Virtual Desktop) 環境。
## 架構
(待補)
## Lab1 - 建立黃金映像 (Golden Image)
1. 建立 Resource group，Resource group name 輸入「AVD-PoC」，Region 選擇「Japan East」
2. 建立 Virtual machine，Resource group 選擇「AVD-PoC」，，Resource group name 輸入「Golden-Image」，Image 選擇「Windows 10 Enterprise multi-session, version 21H2 + Microsoft 365 Apps」
    ![image](https://user-images.githubusercontent.com/42570850/212196092-63c30c52-49cd-4e41-be5b-89cac9529664.png)
3. 安裝 language packs
  * 遠端登入 Golden-Image，開啟 Edge 下載 [language packs](https://learn.microsoft.com/en-us/azure/virtual-desktop/language-packs)
    ![image](https://user-images.githubusercontent.com/42570850/212198451-01f0f8e2-42ac-4b55-a608-31f3fe30e3ab.png)
  * 依序掛載 Language ISO 與 FOD Disk 1 ISO
  * 以常用的繁體中文、簡體中文及日文為例，開啟 Powershell 執行以下指令（參考[Dino9021 的部落格](https://blog.dino9021.com/2021/01/azure-windows-10-multi-session-language.html)）
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

