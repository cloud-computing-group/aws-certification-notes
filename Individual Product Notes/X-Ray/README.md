## A Cloud Guru
  
### What is X-Ray
X-Ray 是可以收集、查看、过滤、分析请求（面向开发者程序应用如 Lambda function 的请求）信息的服务，以帮助开发者定位、分析错误或优化程序。除了可以查看请求和响应的具体信息外，还可以深入查看到服务端应用程序如何调用下游 AWS 资源、微服务、数据库、HTTP web APIs 的信息。  
  
### X-Ray Architecture
首先需要安装 X-Ray SDK 到应用程序里，运行程序时，该 SDK 就会发送 JSON 数据到 X-Ray Daemon（可以安装在 Windows、Linux、OS X 的 PC 端上），Daemon 会监听 UDP 然后当获取该 JSON 后就将其发送至 X-Ray 的 API ，X-Ray API 获取并保存这些 JSON 数据并在 X-Ray 的控制台上数据可视化这些数据。  
  
### X-Ray SDK provides:
* Interceptors to add to your code to trace incomping HTTP requests.
* Client handlers to instrument AWS SDK clients that your application uses to call other AWS services.
* A HTTP client to use to instrument calls to other internal and external HTTP web services.
  
### X-Ray Integration
* ELB
* Lambda
* API Gateway
* EC2
* Elastic Beanstalk
  
### X-Ray supported languages
Java, Go, Node.js, Python, Ruby, .Net  
  
### Lab
1. Create an application (preconfigured platform and sample application) by Elastic Beanstalk.
2. IAM add more permission (full access of S3, DynamoDB, X-Ray etc) to the above application (aws-elasticbeanstalk-ec2-role) Role.
3. Open the web application click button to send request through application to S3 (sample application contains build-in logic with S3 and X-Ray).
4. X-Ray console can see traffic from Elastic Beanstalk app to S3. (have Service Map section for overview and Traces section for detail debug)
5. Update Elastic Beanstalk application with upload custom code which interact with DynamoDB and SNS (therefore see more interaction in X-Ray and can debug if anything goes wrong with X-Ray too, in this case locate error happen in SNS and debug it with X-Ray, click on a Trace can see which part/service thrown the error during the whole request/response process, click on the service can get even more message or say error message).