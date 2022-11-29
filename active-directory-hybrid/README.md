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
## Lab2 - 建立 Azure AD DS
## Lab3 - 安裝 Azure AD Connect
## Lab4 - 將 Domain Computer 加入雲端網域
