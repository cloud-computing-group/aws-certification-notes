## A Cloud Guru
  
### Elastic Beanstalk
* AWS 提供的一个编排服务
* 用来部署和 scale（扩展） web 应用、服务
* 支持 Java、.Net、PHP、Node、Python、Ruby、Go 和 Docker，并支持部署在服务平台如 Apache Tomcat、Nginx、Passenger、IIS etc
  
你只需专注代码逻辑层面开发，其余交由 AWS 处理，完全不用担心基础设施的事情与管理（比如上面的运行语言环境或服务平台管理、维护）：
* 部署、容量开通、负载均衡、自动扩展或缩小、应用健康监控
* 是最快最容易的部署应用至 AWS 的办法
* 你仍然对运行该应用所需的所有 AWS 资源有完全的控制（如 EC2 的实例类型选择、数据库），又或者你可以选择完全交由 Elastic Beanstalk 帮你打理一切
* 更新管理 - 平台的更新比如运行环境、语言、操作系统等无需你操心，可以设置由 Elastic Beanstalk 自动更新
* 可与 CloudWatch 以及 X-Ray 集成以获取性能数据和 Metrics
* 没有额外费用，只需支付运行应用而服务开通的相关 AWS 资源、服务（比如 EC2 实例、S3 bucket 等）
  
### Elastic Beanstalk Lab
1. Elastic Beanstalk 控制台，应用起名
2. 选择技术平台（这里通过选择 Docker，可以选择 AWS 未 preconfigured、支持的编程语言或技术）
3. 上传代码的 zip 文件（或选择 AWS 给的模版代码）
4. 检查并等待创建过程（会有一个终端显示）完成，完成后转至 Dashboard（在这里可以看到刚刚为了创建新应用开通了哪些服务与资源 - 如 EC2 实例及其属性信息等，还可以更新设置、配置比如 Capacity 容量、变更 EC2 实例类型，查看应用日志，应用健康监控、记录，设置警告，查看事件，更新管理等等）
5. 在创建的应用的 Elastic Beanstalk 页面上选择删除应用后，相关资源也会自动删除  
创建应用后，事实上你会看到 CloudFormation 为此应用创建了一个 stack，说明 Elastic Beanstalk 是通过在后端使用 CloudFormation 实现的。所以这个服务适用于请不起或没必要请 SysAdmin、DevOps 工程师的小团队、组织。  
  
### Elastic Beanstalk .ebextensions
https://docs.aws.amazon.com/zh_cn/elasticbeanstalk/latest/dg/ebextensions.html  
* 允许通过一个配置文件进行更高级的 - Elastic Beanstalk 的环境自定义（比如定义哪些安装包、创建 Linux user 或 group、运行 shell 脚本、指定启动的 AWS 服务、设置负载均衡等等）
* 该配置文件里的数据、信息格式应是 JSON 或 YAML 其中一种
* 该配置文件名后缀必须是 .config（文件名可自定义），且应放在一个叫 .ebextensions 的文件夹里，.ebextensions 文件夹则必须放置在你的应用源代码束、文件的 top-level 路径（这也意味着这一自定义功能也可以和其他代码程序一起被版本控制）
* 允许开发者配置系统让其自动部署、系统自动化  
.config 文件示例（配置 ELB 用来做 Application Health check 的 URL）：  
```json
{
    "option_settings": [
        {
            "namespace": "aws.elasticbeanstalk.application",
            "option_name": "My Application HealthCheck URL",
            "value": "/healthcheck"
        }
    ]
}
```
  
### Elastic Beanstalk Deployment Policies（考点）
Elastic Beanstalk 提供以下几种选项进行部署、更新：  
* All at once 更新
    * 同时部署新版本到所有实例
    * 当部署发生时所有实例暂停服务
    * 你的应用、服务在部署进行时 outage，对于 mission-critical 的产品系统十分不推荐（更多可能适用于开发环境）
    * 如果更新失败，你需要通过重新部署旧版本来 rollback 你的所有实例
* Rolling 更新
    * 批处理式地部署更新
    * 部署时，正在更新的那一批实例暂停服务
    * 应用的处理性能会减少那批更新的实例的计算力
    * 不适用于对性能敏感、要求高的系统
    * 如果更新失败，你需要执行一次额外的 rolling 更新去 rollback 之前失败的变更
* Rolling with additional batch 更新
    * 会开通一批额外的实例
    * 在部署过程中保持与原来的应用相同的完整性能
    * 如果更新失败，你需要执行一次额外的 rolling 更新去 rollback 之前失败的变更
* Immutable 更新
    * 部署更新到一组新的实例上以及其新的 Auto Scaling Group
    * 当新的实例们通过 healthy check 之后，它们会替换掉你的已有 Auto Scaling Group 的旧实例并关停删除旧实例们
    * 在部署过程中保持与原来的应用相同的完整性能
    * 更新失败几乎对应用实时服务没有影响，rollback 仅需要做的事是关掉新的 Auto Scaling Group
    * mission-critical 系统应最好选择此方式  
设置 Deployment Policies 可以在 Dashboard 的 Configurations 选项卡的面板里设置。  
  
### Elastic Beanstalk 与 RDS 集成
Elastic Beanstalk 提供两种方式集成 RDS 数据库到你的环境里：  
* Launch within Elastic Beanstalk：通过 Elastic Beanstalk 的控制台随着 Elastic Beanstalk 应用环境开启 RDS（此方式适用于开发与测试环境，不适用于产品环境因为这意味着数据库的生命周期与 Elastic Beanstalk 应用环境的生命周期绑定，一旦该应用环境被删除则数据库也被同时删除）
* Launch outside Elastic Beanstalk：在 Elastic Beanstalk 外即直接在 RDS 平台上创建数据库实例，解耦 Elastic Beanstalk 应用环境与 RDS 数据库，此方式带来更多的灵活度 - 连接多个不同环境到一个数据库、更多的数据库配置选择、在 Elastic Beanstalk 应用环境关停删除的情况下也不影响原数据库使用。（此方式适用于产品环境）  
  
Elastic Beanstalk 应用连接外部（RDS）数据库，需完成以下两步配置：  
* 一个额外的 Security Group 需要添加至你的 Elastic Beanstalk 应用环境的 Auto Scaling Group
* 提供与数据库连接的配置信息（字符串）给 Elastic Beanstalk 应用的实例服务器们（数据库 endpoint、数据库连接用的账号与密码、以及其他连接参数等等）
  
### 更多细节
使用 Elastic Beanstalk 后，它会创建一个 S3 bucket 存放你每次上传的代码、应用程序（如版本控制一般，你可以在 Elastic Beanstalk 控制台点击选择该应用 -> Application versions，就可以看到了、也可以在那里手动选择版本进行部署，也可以直接去 S3 里找）。