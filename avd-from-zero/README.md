# 從零開始創建 AVD 環境
本文透過實際演練，示範如何從零開始創建一整套 AVD (Azure Virtual Desktop) 環境。
## 架構
(待補)
## Lab1 - 建立黃金映像 (Golden Image)
1. 建立 resource group，resource group name 輸入「AVD-PoC」，region 選擇「Japan East」
2. 建立 virtual machine，resource group 選擇「AVD-PoC」，，resource group name 輸入「Golden-Image」，image 選擇「Windows 10 Enterprise multi-session, version 21H2 + Microsoft 365 Apps」
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

  * 卸載 Language ISO 與 FOD Disk 1 ISO，並刪除這兩個 ISO 檔（資源回收桶也清空）
4. 依實際需求，安裝 LOB (Line of Business) 應用程式，例如 Acrobat Reader、Photoshop、AutoCAD 等
