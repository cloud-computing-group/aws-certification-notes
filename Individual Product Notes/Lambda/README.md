## A Cloud Guru
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
  
### Price
基于两个因素：
1. 请求量（request）- 每月的前100万次请求免费。
2. 单次处理耗费资源（duration）- 每次请求总处理时间大概会控制为100ms，因此若程序要处理的是较为繁重的计算时就会消耗更多的内存，因此最后将以 GB/sec 为计量单位计算费用。(对于繁重的计算任务，需要更多的内存，因此内存可能要配置提升，如果超过配置的内存处理可能会失败)
  
### Exam Tips
* Lambda scales out (not up) automatically.
* Lambda functions are independent, 1 event = 1 function
* Lambda is serverless
* Which services are serverless?: Lambda, API Gateway, S3, DynamoDB, Serverless Aurora etc.
* Lambda function can trigger other lambda functions, 1 event = X functions if functions trigger functions.
* Architectures can get extremely complicated, AWS X-ray allows you to debug what is happening.
* Lambda can do things globally, can use it to backup S3 buckets to other S3 buckets (different regions) etc.
* Lambda triggers (has many).
  
### Lambda 的版本控制
当对 Lambda function 进行版本控制时，可以 publish 一个或多个该 function 的版本，因此可以允许开发者在其的开发工作流程里保有多个不同的分支（development、beta、production etc）。  
每一个 Lambda function 的版本都有一个唯一的 ARN（Amazon Resource Name）。一旦版本 publish（发布后），该 ARN 再不能修改。  
AWS Lambda 会保存缓存你的最近更新的 function 代码，并存于一个叫 $LATEST 的版本里，当你更新你的 function 代码时，新的代码就会自动覆盖更新这个版本。  
  
### Qualified / Unqualified ARN
* 当需要引用某个 Lambda function 时，可以使用其 ARN（Amazon Resource Name）来引用它（比如写 role 配置或 terraform 时）。有两种 ARN 与此缓存版本（$LATEST）关联：
* Qualified ARN - function ARN 带版本 suffix：arn:aws:lambda:aws-region:acc-id:function:helloworld:$LATEST
* Unqualified ARN - function ARN 没有带版本 suffix：arn:aws:lambda:aws-region:acc-id:function:helloworld
  
### Alias
可以创建一个 Alias 指向任何一个版本，好处在于当打算在产品实用更新到其他版本时，可以只把 Alias 指向的版本设置更新（remapping）即可，则引用该 Alias 的 ARN 的代码或配置等都不需要改动（比如引用 ARN 的 Terraform），如果新版本出了问题，roll back 也十分简单只需要把 PROD Alias remapping 回原先版本即可。  
Alias 还有一个强大的功能是可以指向多个版本（split traffic），即运行或收到请求时，可以被设置为将其中一定比例的请求指向版本A，另外一定比例的请求指向版本B。
  
### Exam Tips
* Can have multiple version of lambda functions.
* Latest version will use $LATEST
* Qualified version will use $LATEST, unqualified version will not have it.
* Versions are immutable (That version's lambda function code cannot be changed).
* Can split traffic using aliases to different versions.
    * Cannot split traffic with $LATEST, instead create an alias to latest.
  
### An Introduction to Alexa
* Skill Service: AWS Lambda
* Skill Interface: Invocation Name, Intent Schema, Slot Type, Utterances
Make an Alexa Skill Lab:  
1. Create S3 Bucket for store mp3 files, go to AWS Polly service and upload some text, then click generate speech (mp3 file) and send to the S3 bucket (config the url in AWS Polly service).  
2. Create a Lambda to respond a Alexa command / utterance (there is public Lambda code available on AWS Lambda blueprint for free, just create Lambda function based on the blueprint), in the code can change "data" variable point to the S3 bucket's mp3 file's url.  
3. Copy the created Lambda ARN, open / login Alexa official web console, create new Fact skill and paste the ARN to Endpoint -> AWS Lambda ARN, set utterance to trigger that Lambda, click "build model".  
4. Know can online test or really talk to Alexa with that command / utterance to trigger and hear that mp3 sound.  
  
### 触发源
包括但不限于：  
* S3 bucket（Event Type 可以是PUT、POST、COPY etc，还可以指定触发必须是 bucket 的某个 directory 下或者 bucket 存储的某类文件类型）
* DynamoDB table
* Kinesis Stream
* SQS notification
* API Gateway
  
  
  
## 实践
2019 年 AWS 官方文档资料（Lambda 请求参数负载限制）：  
如果是 API Gateway 调用 lambda function (默认设置即不强制使用 asynchronous invocation; 如果想强制设置请参考: https://docs.aws.amazon.com/zh_cn/apigateway/latest/developerguide/set-up-lambda-integration-async.html, 同时这也是检查是否被设置的方法), 则 API Gateway 请求数据大小限制是 `10 MB` 而 Lambda 请求负载数据限制是 `6 MB` (包括 HTTP/HTTPS 的 headers, authorization 等等)。  
而大部分 event drive 的 Lambda function, 比如 S3 trigger 则是 asynchronous invocation, 而此时相关 Lambda function 的请求负载数据限制是 `256 KB`。  
参考：https://www.stackery.io/blog/RequestEntityTooLargeException-aws-lambda-message-invocation-limits/