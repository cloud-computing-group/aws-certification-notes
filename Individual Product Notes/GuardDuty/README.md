## A Cloud Guru
  
### 什么是 GuardDuty
威胁检测服务，持续地监控恶意软件、程序以及未经许可、认证的操作。  
收费服务（30 天免费试用）。  
  
### How
通过监控以下：  
* 不寻常 API 调用
* 未经认证的部署
* 被破解的实例
以及在你的账号上使用以下技术：  
* 威胁智能补充
* 机器学习
* CloudWatch 事件  
  
可以通过在 AWS 控制台启动此服务，然后 GuardDuty 会自动地持续地分析你的账号的各项资源、服务情况，使用机器学习和威胁智能机制检测出具体问题，分析、检测结果会在控制台展示，你也可以将其集成在日志里，发出警告或触发 Lambda 函数。  
GuardDuty 默认自动发提示到 CloudWatch 事件。  
  
### Lab
Service Role Permission - 用来监控你的数据源。  
可以产生 sample finding（威胁）用于测试。  
可以增添检测的 AWS 账号。  
  
### 费用
费用基于 2 个因素：  
* CloudTrail 事件分析质量
* VPC Flow Log 和 DNS Log Data 分析的量