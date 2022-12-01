# 以 IaC 建構 DR 環境
使用 ARM (Azure Resource Manager) 與 Terraform 在 Azure 上建構 DR (Disaster Recovery) 環境
## 架構
![2022-12-01_113910](https://user-images.githubusercontent.com/42570850/204960410-743fb53f-55e8-488b-96b3-56d5b69075ce.jpg)
* 架構說明
  * 主站點在東京 (Japan East)，備援點在新加坡 (Southeast Asia)
  * 當災難發生時，備援點的 VM 才會被建立並開機
## Lab1 - ARM
1. 建置主站點
	* 登入 Azure Portal，新建 Resource Group，名稱輸入「SourceRG」，Region 選擇 Japan East，點選「Review + create」，接著點選「Create」
	
	![2022-12-01_133505](https://user-images.githubusercontent.com/42570850/204974193-fb8433b1-f274-496e-b4db-39e14d899978.jpg)
  
	* 點擊下方按鈕
	
	[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmars0426%2FAzure-Labs%2Fmain%2Fdisaster-recovery-iac%2Fdr-source.json)
	
	* Resource group 選擇「SourceRG」，點選「Review + create」，接著點選「Create」
2. 建置備援點
	* 登入 Azure Portal，新建 Resource Group，名稱輸入「TargetRG」，Region 選擇 Southeast Asia，點選「Review + create」，接著點選「Create」
	* 點擊下方按鈕
	
	[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmars0426%2FAzure-Labs%2Fmain%2Fdisaster-recovery-iac%2Fdr-target.json)
	
	* Resource group 選擇「SourceRG」，點選「Review + create」，接著點選「Create」
## Lab2 - Terraform
