# Azure 靜態網站代管搭配 Azure Front Door
本文透過實際演練，示範如何使用 Azure Blob Storage 搭配 Azure Front Door 快速建構靜態網站。
## 架構

![image](https://user-images.githubusercontent.com/42570850/212449195-1b9bfcef-e677-4478-9514-da439672a8b5.png)

* 架構說明
  * 網站的內容存放在 Azure Blob Storage，前端由 Azure Front Door 提供快速、可靠且安全的存取
* 比較
  * 在 Azure 上利用 SaaS/PaaS 建構網站，大致有 Azure Blob Storage、Azure Static Web Apps 及 Azure App Service 三種方式，簡單比較如下圖

  ![image](https://user-images.githubusercontent.com/42570850/212449302-ce624ec8-cd61-4be5-97aa-38c5858c415b.png)

## Lab1 - 建罝靜態網站
1. 啟用 Static website
  * 建立一個 Storage account，從左方選單點選「Static website」，將 Static website 設為「Enabled」，可另外設定網站的預設網頁 (Index document) 與錯誤回應網頁 (Error document)，設定完成後點選「Save」

  ![image](https://user-images.githubusercontent.com/42570850/212450259-e17cfa4b-3ecc-4a9f-a622-32157a4d3799.png)


  * 啟用後，就會產生網站的網址（可先將此網址複製到文字檔備用），也會自動建立一個名稱為 $web 的 container，讓我們上傳網站的相關檔案

  ![image](https://user-images.githubusercontent.com/42570850/212450282-c78b77e8-74b4-4e6b-b759-db5392b85271.png)

  ![image](https://user-images.githubusercontent.com/42570850/212450283-4ac8a301-351b-4cb3-ab0b-0a80ce9694ab.png)

2. 上傳網站檔案
  * 下載並安裝 [Azure Storage Explorer](https://azure.microsoft.com/zh-tw/products/storage/storage-explorer/)，登入 Azure 帳號，從左方樹狀圖選取 $web，上傳資料夾或檔案

  ![image](https://user-images.githubusercontent.com/42570850/212449769-df108b8e-8da4-41d4-a248-bdec929a5bff.png)

  * 如果在步驟 1 有指定預設網頁或錯誤回應網頁，也要上傳對應的檔案
  * 開啟瀏覽器，輸入步驟 1 的網站網址，即可看到我們上傳的網頁

  ![image](https://user-images.githubusercontent.com/42570850/212450302-f423ff5f-fd9f-4b08-9a5e-0909345312e0.png)

## Lab2 - 設定 Azure Front Door
1. 建立 Front Door and CDN profiles，選擇「Explore other offerings」，選擇「Azure Front Door (classic)」，點選 Continue

  ![image](https://user-images.githubusercontent.com/42570850/212450334-c39aeac4-8cd9-446a-9ce5-4b5442f67205.png)

2. 選擇 Resource group，點選「Next: Configuration」

  ![image](https://user-images.githubusercontent.com/42570850/212450343-ba549002-662b-4c9f-bb28-b26b1dacb075.png)

3. Frontends/domains 點選「+」，輸入 Host name，選擇是否要啟用 Session Affinity 或 WAF，點選「Add」

  ![image](https://user-images.githubusercontent.com/42570850/212450362-6e825706-8f3b-486d-876e-4b7376076929.png)

4. Backend pools 點選 「+」，輸入 Backend pool name，點選「Add a backend」，Backend host type 選擇「Custom host」，Backend host name 輸入 Lab1 複製的網站網址（去掉開頭的 https:// 與結尾的 /），點選「Add」

  ![image](https://user-images.githubusercontent.com/42570850/212450367-cecb5ab4-0fbe-4f48-ae8f-22581d2a0693.png)

  ![image](https://user-images.githubusercontent.com/42570850/212450373-742b7b14-fb03-4dcf-9bfc-e84159fe028e.png)

5. Routing rules 點選 「+」，輸入 Name，點選「Add」，點選「Review + create」→「create」

  ![image](https://user-images.githubusercontent.com/42570850/212450387-946fc45a-b8a0-4e37-8c7f-6e65905e43be.png)

  ![image](https://user-images.githubusercontent.com/42570850/212450392-5e725875-4c39-4b10-a621-bfe64485cde1.png)

6. 建立完成後，開啟瀏覽器，輸入網址 https://[hostname].azurefd.net，即可看到網站的預設網頁

  ![image](https://user-images.githubusercontent.com/42570850/212450399-9ac4f53d-f22a-4bc9-a0c8-f65d287f63ce.png)
