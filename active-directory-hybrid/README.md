# 混合環境下以 Azure AD DS 作為地端 AD DS 的備援
本文透過實際演練，示範如何在混合環境下以 Azure AD DS 作為地端 AD DS 的備援。
## 架構
![2022-11-29_163143](https://user-images.githubusercontent.com/42570850/204478613-cc53a4e8-d03a-40f5-9672-8dffe27290c9.jpg)

* 架構說明
	* 在 Azure 建立兩台 VM 模擬地端環境，一台 Domain Controller，一台 Domain Computer。
	* 地端模擬環境使用網段 10.0.0.0/16。
	* Azure AD DS 使用網段 10.1.0.0/24。
	* 以 VNET peering 模擬 S2S VPN 串連地端網路與雲端網路。
* 目標
  * Domain Controller 關機後，使用者仍可透過 Azure AD DS 認證遠端登入 Domain Computer。
## Lab1 - 建立地端模擬環境
1. 建立 Domain Controller
	* 新增資源: virtual machine
		* 選取您的 Subscription，新建 Resource group，Virtual machine name 輸入「dcontroller」，Region 選擇「East Asia」
		* ![2022-11-29_182834](https://user-images.githubusercontent.com/42570850/204505318-5f3f0834-19a4-40fd-94a5-8728ebd17672.png)

		* Image 選擇「Windows Server 2016 Datacenter - Gen2」，輸入 Username、Password、Confirm password，點選「Review + create」，接著點選「Create」
		* ![2022-11-29_183226](https://user-images.githubusercontent.com/42570850/204506737-eea10eb5-e399-4ba2-8c8e-f74fb35307a3.png)

2. 
## Lab2 - 建立 Azure AD DS
## Lab3 - 安裝 Azure AD Connect
## Lab4 - 將 Domain Computer 加入雲端網域
