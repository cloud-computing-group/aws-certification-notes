## A Cloud Guru
  
### What is SES
SES 是可扩展及高可用的邮件服务，用来帮助市场部或应用开发者发送市场营销、通知、交易信息邮件给客户，该服务按用付费。  
SES 也可以用来接收邮件：接收到的邮件自动存放在 S3 中。  
接收到的邮件也可以用来触发 Lambda 函数或 SNS 通知。  
  
### SES VS SNS
SES 是 Email only 的，不是基于订阅机制的，只需要邮箱地址即可。  
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/master/Individual%20Product%20Notes/SES/SES%20VS%20SNS.png)
  
### SES use case
* 自动化邮件
* 购买确认、购物通知、订单状态更新
* 每次客户预付款电话费时运营商自动发送通知给客户
* 市场营销沟通、广告、特殊订单、新闻简报
* 在线零售厂商通知客户有打折或推广活动  
