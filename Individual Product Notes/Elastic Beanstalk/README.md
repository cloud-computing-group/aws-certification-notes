## A Cloud Guru
  
### Elastic Beanstalk
* AWS 提供的一个编排服务
* 用来部署和 scale（扩展） web 应用、服务
* 支持 Java、.Net、PHP、Node、Python、Ruby、Go 和 Docker
  
你只需专注代码逻辑层面开发，其余交由 AWS 处理：
* 部署、容量开通、负载均衡、自动扩展、应用健康监控
* 是最快最容易的部署应用至 AWS 的办法
* 你仍然对 AWS 资源有完全的控制（如数据库）
* 没有额外费用，只需支付运行应用而服务开通的相关 AWS 资源、服务
  
### Elastic Beanstalk Lab
1. Elastic Beanstalk 控制台，应用起名
2. 选择技术平台（这里通过选择 Docker，可以选择 AWS 未 preconfigured、支持的编程语言或技术）
3. 上传代码的 zip 文件（或选择 AWS 给的模版代码）
4. 检查并等待创建过程（会有一个终端显示）完成，完成后转至 Dashboard（在这里可以更新设置、配置比如 Capacity 容量，查看应用日志，应用健康监控、记录，设置警告，查看事件，更新管理等等）  
事实上你会看到 CloudFormation 为此应用创建了一个 stack，说明 Elastic Beanstalk 是通过在后端使用 CloudFormation 实现的。所以这个服务适用于请不起或没必要请 SysAdmin、DevOps 工程师的小团队、组织。  
  
### Elastic Beanstalk .ebextensions
https://docs.aws.amazon.com/zh_cn/elasticbeanstalk/latest/dg/ebextensions.html  
* 允许通过一个配置文件进行更高级的环境自定义
* 该配置文件格式应是 JSON 或 YAML 其中一种
* 这些配置信息、数据应放在一个叫 .ebextensions 的文件夹里
* 允许开发者配置系统让其自动部署、系统自动化  
