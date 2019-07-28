## A Cloud Guru
  
### 什么是 SNS
SNS 是可以从云平台发送通知（notification）的服务，setup 与操作都简易方便。  
SNS 提供给开发者高可扩展、灵活以及低成本的消息发布服务，消息从应用或平台发出并可以即时传递给消息的订阅者或应用。  
可以发布、推送消息至手机设备（可以通过百度云推送发给中国的安卓手机设备）。  
  
* 除了推送云平台消息到硬件设备，SNS 也可以通过 SMS 或邮件来传递 notification 到 SQS 队列以及任意 HTTP endpoint。
* SNS 也可以触发 Lambda 函数：当有 SNS 消息发布，且消息的 topic 是某 Lambda 函数订阅 topic，则 Lambda 函数会被触发并加载该 notification 消息的 payload，然后函数可以处理该 payload 信息并最终生成发布另一个 topic 的 SNS 消息或发送消息给其他 AWS 服务。  
  
### SNS topic
SNS 允许你组织多个受众消费同一个 topic，一个 topic 是让多个受众动态地订阅某类消息的访问点。  
一个 topic 支持传递给多个 endpoint 类型 - 比如，你可以把 iOS、安卓和 SMS 组成一个受众组。当每一次发布该 topic 的消息，SNS 会以合适的格式传递该消息给每一个订阅的服务、应用。  
为了保证消息不丢失，所有发布到 AWS SNS 的消息会冗余存放在多个 availability zone。  
  
### SNS 好处
* 实时地、push base 传递
* 简单易用的 API 及与其他服务、应用集成
* 灵活的消息传递，支持多种协议
* 低成本，按用付费且没有预付费
* AWS SNS 控制台简单易用  
  
### SNS VS SQS
都是 AWS 消息管理平台、服务。  
  
### SNS 价格
* $0.5 每 100 万 SNS 请求
* 每 10 万 SNS HTTP 传递 $0.06
* 每 100 条通过 SMS 传递的 SNS notification $0.75
* 每 10 万 SNS Email 传递 $2  
  
### 更多
SNS 提供了发布-订阅机制，如此就不需要周期性的轮询或拉取新消息（如 SQS）。  
SNS 提供简单易用的开发机制，只需前期做一些开发准备开发者就可以为他们的应用使用、集成 SNS API。  
  