Serverless Architecture 的关键组件包括:  
0. 客户端（如手机、PC端的应用、浏览器或其他服务器应用或 IoT 设备）
1. Blob Storage (比如 S3)
2. API Gateway
3. 数据库（比如 DynamoDB、RDS）
4. Function（包括 Step Function）
5. 身份认证及授权服务、身份安全服务（比如 Cognito、Auth0、Active Directory、IAM）
6. 第三方平台、线上软件或 SaaS（比如 CRM、支付系统，其他云服务、平台）
7. CDN 及负载均衡
8. On-Premise
9. 消息队列服务（比如 SQS、Kinesis、Redis）
10. 推送服务（比如 SNS、SES、SMS）
11. 其他容器微服务或 monolith
12. 监控服务（比如 CloudWatch、Elasticsearch Service）
13. 其他内部系统、架构（比如某业务或大数据分析的系统、架构）  
  
实际架构中不限于以上组件，还可能有比如 VPC（NAT Gateway）、KMS 等等。  
更多参考：  
https://hackernoon.com/what-is-serverless-architecture-what-are-its-pros-and-cons-cc4b804022e9