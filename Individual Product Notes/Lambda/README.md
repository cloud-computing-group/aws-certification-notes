### A Cloud Guru
Lambda's layer in real:
* Data Centers
* Hardware (Server, Switch, Router, Firewall, Load Balance etc)
* Assembly Code / Protocols
* High Level Languages
* Operating System
* Application Layers / AWS API
* AWS Lambda
  
Lambda是 AWS 提供的只需按使用的计算时间付费的可运行开发者代码的云服务。只需要上传自己的代码即可用，无需开发者自己配置 infrastructure 以及 patching，scaling。意味着和过去的互联网开发不同，开发者不再需要物理服务器甚至 VM 甚至容器，也不需要操心 infrastructure 的维护、管理，完全专注于程序、业务代码即可。  
* Lambda 可以是一个 event-drive compute service，可以运行你的代码以响应任何事件（event）（包括 S3 内数据更新或 DynamoDB 表中数据更新）。
* Lambda 也可以专门为自定义的 API Gateway 被 HTTP 请求时或被 AWS SDKs 的 API 请求时做出响应、运行自定义的代码与程序。
  
## Price
基于两个因素：
1. 请求量（request）- 每年的前100万次请求免费。
2. 单次处理耗费资源（duration）- 每次请求总处理时间大概会控制为100ms，因此若程序要处理的是较为繁重的计算时就会消耗更多的内存，因此最后将以 GB/sec 为计量单位计算费用。(对于繁重的计算任务，需要更多的内存，因此内存可能要配置提升，如果超过配置的内存处理可能会失败)
  
## Exam Tips
* Lambda scales out (not up) automatically.
* Lambda functions are independent, 1 event = 1 function
* Lambda is serverless
* Which services are serverless?: Lambda, API Gateway, S3, DynamoDB, Serverless Aurora etc.
* Lambda function can trigger other lambda functions, 1 event = X functions if functions trigger functions.
* Architectures can get extremely complicated, AWS X-ray allows you to debug what is happening.
* Lambda can do things globally, can use it to backup S3 buckets to other S3 buckets (different regions) etc.
* Lambda triggers (has many).