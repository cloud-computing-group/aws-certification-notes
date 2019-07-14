## A Cloud Guru
  
### Elastic Beanstalk
* AWS 提供的一个编排服务
* 用来部署和 scale（扩展） web 应用、服务
* 支持 Java、.Net、PHP、Node、Python、Ruby、Go 和 Docker，并支持部署在服务平台如 Apache Tomcat、Nginx、Passenger、IIS etc
  
你只需专注代码逻辑层面开发，其余交由 AWS 处理，完全不用担心基础设施的事情与管理（比如上面的运行语言环境或服务平台管理、维护）：
* 部署、容量开通、负载均衡、自动扩展或缩小、应用健康监控
* 是最快最容易的部署应用至 AWS 的办法
* 你仍然对运行该应用所需的所有 AWS 资源有完全的控制（如 EC2 实例、数据库），又或者你可以选择完全交由 Elastic Beanstalk 帮你打理一切
* 更新管理 - 平台的更新比如运行环境、语言、操作系统等无需你操心，可以设置由 Elastic Beanstalk 自动更新
* 可与 CloudWatch 以及 X-Ray 集成以获取性能数据和 Metrics
* 没有额外费用，只需支付运行应用而服务开通的相关 AWS 资源、服务（比如 EC2 实例、S3 bucket 等）
  
### Elastic Beanstalk Lab
1. Elastic Beanstalk 控制台，应用起名
2. 选择技术平台（这里通过选择 Docker，可以选择 AWS 未 preconfigured、支持的编程语言或技术）
3. 上传代码的 zip 文件（或选择 AWS 给的模版代码）
4. 检查并等待创建过程（会有一个终端显示）完成，完成后转至 Dashboard（在这里可以看到刚刚为了创建新应用开通了哪些服务与资源 - 如 EC2 实例及其属性信息等，还可以更新设置、配置比如 Capacity 容量，查看应用日志，应用健康监控、记录，设置警告，查看事件，更新管理等等）
5. 在创建的应用的 Elastic Beanstalk 页面上选择删除应用后，相关资源也会自动删除  
创建应用后，事实上你会看到 CloudFormation 为此应用创建了一个 stack，说明 Elastic Beanstalk 是通过在后端使用 CloudFormation 实现的。所以这个服务适用于请不起或没必要请 SysAdmin、DevOps 工程师的小团队、组织。  
  
### Elastic Beanstalk .ebextensions
https://docs.aws.amazon.com/zh_cn/elasticbeanstalk/latest/dg/ebextensions.html  
* 允许通过一个配置文件进行更高级的环境自定义
* 该配置文件格式应是 JSON 或 YAML 其中一种
* 这些配置信息、数据应放在一个叫 .ebextensions 的文件夹里
* 允许开发者配置系统让其自动部署、系统自动化  
