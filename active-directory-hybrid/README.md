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
	* 新建 virtual machine
		* 選取您的 Subscription，新建 Resource group，Resource group name 輸入「active-directory-hybrid」，Virtual machine name 輸入「dcontroller」，Region 選擇「East Asia」
		* ![2022-11-29_182834](https://user-images.githubusercontent.com/42570850/204505318-5f3f0834-19a4-40fd-94a5-8728ebd17672.png)
		* Image 選擇「Windows Server 2016 Datacenter - Gen2」，Username 輸入「onpremuser1」、Password、Confirm password 輸入「Active@dHybr1d」，點選「Review + create」，接著點選「Create」
		* ![2022-11-29_183226](https://user-images.githubusercontent.com/42570850/204506737-eea10eb5-e399-4ba2-8c8e-f74fb35307a3.png)
	* 升級 domain controller
		* 使用帳號 onpremuser1 遠端登入 dcontroller，開啟 Server Manager，點選「Add roles and features」
		* ![2022-11-29_185712](https://user-images.githubusercontent.com/42570850/204511776-45cc692b-1219-4ce2-a8f4-d871940070d0.png)
		* 點選「Next」直到 Server Roles，勾選「Active Directory Domain Services」，繼續點選「Next」直到 Confirmation，點選「Install」
		* ![2022-11-30_045641](https://user-images.githubusercontent.com/42570850/204646125-3981bd26-e463-4c0d-a777-1564db980cc8.png)
		* 完成後回到 Server Manager，點選右上角黃色驚嘆號，點選「Promote this server to a domain controller」
		* ![2022-11-29_191409](https://user-images.githubusercontent.com/42570850/204516204-2c7d07d0-d5e3-4419-b1ee-72087b4f81b4.png)
		* 選擇「Add a new forest」，Root domain 輸入「chtdnadmin.tw」，點選「Next」
		* ![2022-11-29_192250](https://user-images.githubusercontent.com/42570850/204516975-9d619634-7523-403d-961e-6a9b7c8aa8f0.png)
		* Password、Confirm password 輸入「Active@dHybr1d」，點選「Next」直到 Prerequisites Check，點選「Install」，安裝完成後自動重啟
2. 建立 Domain Computer
	* 新建 virtual machine
		* (參考建立 Domain Controller) 選取您的 Subscription，Resource group 選擇「active-directory-hybrid」，Virtual machine name 輸入「dcomputer」，Region 選擇「East Asia」
		* Image 選擇「Windows Server 2016 Datacenter - Gen2」，Username 輸入「onpremuser2」、Password、Confirm password 輸入「Active@dHybr1d」，點選「Review + create」，接著點選「Create」
	* 加入 domain
		* 使用帳號 onpremuser2 遠端登入 dcomputer，變更網卡設定，Preferred DNS Server 輸入「10.0.0.4」（dcontroller 的 IP），點選「OK」，點選「Close」，重啟 dcomputer
		* ![2022-11-29_194714](https://user-images.githubusercontent.com/42570850/204521652-9a273931-d7cd-4bf8-a669-820c7fcfc468.png)
		* 使用帳號 onpremuser2 遠端登入 dcomputer，開啟 Control Panel，點選 System and Security，點選 System，點選「Change settings」
		* ![2022-11-29_195412](https://user-images.githubusercontent.com/42570850/204522497-f4004d81-8e91-45f1-b683-027892e9023a.png)
		* 點選「Change」，選擇「Domain」，輸入「chtdnadmin.tw」，點選「OK」
		* ![2022-11-29_195603](https://user-images.githubusercontent.com/42570850/204523229-3e4147a4-9622-49fc-8ba4-bea1adba71f9.png)
		* Username 輸入「onpremuser1」，Password「Active@dHybr1d」輸入，點選「OK」，出現「Welcome to the chtdnadmin.tw domain」訊息，點選「OK」，重啟 dcomputer
	* 測試 domain 帳號登入
		* 使用帳號 onpremuser1 遠端登入 dcontroller，開啟 Active Directory Users and Computers，點選 Create a new user 圖示，First name 輸入「mars」，User logon name 輸入「mars」，點選「Next」，Password、Confirm password 輸入「Active@dHybr1d」，取消勾選 「User must change password at next logon」，點選「Next」，點選「Finish」
		* ![2022-11-29_200720](https://user-images.githubusercontent.com/42570850/204525585-10671852-3e10-42d3-a308-d723933991ee.png)
		* 雙擊剛新增的 user，切換到「Member of」，點選「Add」，object name 輸入「Domain Admins」，點選「OK」
		* 再次點選「Add」，object name 輸入「Enterprise Admins」，點選「OK」，再次點選「OK」關閉 Properties 視窗
		* ![2022-11-29_201214](https://user-images.githubusercontent.com/42570850/204526505-5f53f809-79a6-470b-96d3-a31f0f1dcaca.png)
		* 使用帳號 chtdnadmin.tw\mars 遠端登入 dcomputer，確認可成功登入
## Lab2 - 建立 Azure AD DS
1. 新增 custom domain
	* 登入 Azure Portal，進入 Azure Active Directory，點選左側「Custom domain names」，點選「Add custom domain」，Custom domain name 輸入「chtdnadmin.tw」，點選「Add domain」（不需點擊「Verify」）。
	* ![2022-11-29_202206](https://user-images.githubusercontent.com/42570850/204528951-93e07f91-4d02-40dc-bc3f-1b6cb82e3f14.png)
2. 新建 Azure AD Domain Services
	* 選取您的 Subscription，Resource group 選擇「active-directory-hybrid」，DNS domain name 輸入「chtdnadmin.tw」，Region 選擇「East Asia」，點選「Review + create」，接著點選「Create」，點選「OK」
	* ![2022-11-29_203139](https://user-images.githubusercontent.com/42570850/204530902-a47db446-b942-4ab1-86fc-3b81089de4fb.png)
	* 部署完成後，等待狀態從「Deploying」變成「Running」
	* ![2022-11-29_213524](https://user-images.githubusercontent.com/42570850/204543125-f918883b-0aa8-46cc-ab73-ede04b3e09ff.png)
## Lab3 - 建立 AD 同步機制
1. VNET peering
	* 登入 Azure Portal，進入 Virtual Networks，選取「active-directory-hybrid-vnet」，點選左側「Peerings」，點選「Add」
	* ![2022-11-29_212136](https://user-images.githubusercontent.com/42570850/204540219-c89ee4c1-41ff-4d7a-b526-ea01f7294b29.png)
	* This virtual network Peering link name 輸入「onprem-to-cloud」，Remote virtual network Peering link name 輸入「cloud-to-onprem」，Virtual Network 選取「aadds-vnet」，點選「Add」
	* ![2022-11-29_212747](https://user-images.githubusercontent.com/42570850/204541277-19e197da-08a1-45c4-bbbe-2eda73a0fae5.png)
2. 安裝 Azure AD Connect
	* 使用帳號 onpremuser1 遠端登入 dcontroller，下載 [Azure AD Connect](https://www.microsoft.com/en-us/download/details.aspx?id=47594)
	* 雙撃安裝程式，勾選「I agree...」，點選「Continue」，點選「Customize」，點選「Install」
	* User sign-in 選擇「Password Hash Synchronization」，點選「Next」
	* 輸入您的 Azure Username 與 Password，點選「Next」
	* ![2022-11-29_214155](https://user-images.githubusercontent.com/42570850/204544714-e911dda0-c7d7-4bcd-b659-d9976d9212e7.png)
	* 點選「Add Directory」，Username 輸入「chtdnadmin.tw\mars」，Password 輸入「Active@dHybr1d」，點選「OK」，點選「Next」
	* ![2022-11-29_215808](https://user-images.githubusercontent.com/42570850/204548459-28f9954a-fd8e-4441-8d1a-01cac54dacf7.png)
	* 點選「Next」直到 Configure，點選「Install」，安裝完成後點選「Exit」離開安裝程式
	* 登入 Azure Portal，進入 Azure Active Directory，點選左側「Users」，可以看到從地端模擬環境同步到雲端的使用者
	* ![2022-11-29_220700](https://user-images.githubusercontent.com/42570850/204550876-1709311d-f7f8-40f8-98c7-6d9ae198bb20.png)
## Lab4 - 將 Domain Computer 加入雲端網域
1. temp
	* 使用帳號 chtdnadmin.tw\mars 遠端登入 dcomputer，變更網卡設定，Alternate DNS Server 輸入「10.1.0.4」（Azure AD DS 的 IP），點選「OK」，點選「Close」，重啟 dcomputer
	* ![2022-11-30_093154](https://user-images.githubusercontent.com/42570850/204685659-85eb3717-1f24-4e09-9630-497185cf8bb6.jpg)
	* 使用帳號 chtdnadmin.tw\mars 遠端登入 dcomputer，確認可成功登入
	* 退出 dcomputer 遠端登入，將 dcontroller 關機，再次使用帳號 chtdnadmin.tw\mars 遠端登入 dcomputer，出現訊息「The security database...」，無法登入
	* ![2022-11-30_094245](https://user-images.githubusercontent.com/42570850/204687141-a6b93043-2b3e-4445-a397-d576b88f39b7.jpg)
	* 
3. 加入雲端網域
	* 使用帳號 chtdnadmin.tw\mars 遠端登入 dcomputer，退出 chtdnadmin.tw 網域，重啟 dcomputer
	* 使用帳號 onpremuser2 遠端登入 dcomputer，將 Preferred DNS Server 改成 10.1.0.4，重啟 onpremuser2
	* 使用帳號 onpremuser2 遠端登入 dcomputer，加入 chtdnadmin.tw 網域（加入時需要輸入帳號 mars 及其密碼），重啟 dcomputer
	* 使用帳號 onpremuser2 遠端登入 dcomputer，開啟 System Properties，切換到「Remote」，點選「Select Users」
	* ![2022-11-29_225302](https://user-images.githubusercontent.com/42570850/204562057-4b8b37b4-adb2-4018-986f-43b549fb3123.png)
	* 點選「Add」，object name 輸入「mars」，點選「Check Name」（需要輸入帳號 mars 及其密碼），點選「OK」，點選「OK」
	* ![2022-11-29_225429](https://user-images.githubusercontent.com/42570850/204563240-1b781bda-da4c-4b5a-b236-c3d119f56ce2.png)
	* 關閉 dcomputer 的遠端連線，此時就可使用 chtdnadmin.tw\mars 遠端登入 dcomputer
4. 設定 DNS
	* 使用帳號 onpremuser2 遠端登入 dcomputer，將 Preferred DNS Server 改成 10.0.0.4，Alternate DNS Server 改成 10.1.0.4，重啟 onpremuser2
