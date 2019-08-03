## A Cloud Guru
  
### 什么是 AWS System Manager（SSM）
* SSM 是可以帮你展开全局视角、控制 AWS 基础设施、架构的管理工具。
* 与 CloudWatch 集成，可以让你查看 dashboard、查看操作数据以及监测到问题、报错。
* 包括协助在跨资源、平台上运行命令行以进行自动化任务（比如进行安全补丁、包安装）
* 组织你的库存、根据应用或环境（包括 on-premises 系统）对资源进行分组  
* 降低成本
  
运行命令行：  
* 比如可以在多个 EC2 实例上运行预定义命令
* 对实例执行停止、重启、关闭删除、更新大小等操作
* 增添或移除 EBS 卷
* 创建快照、备份 DynamoDB 表
* 执行补丁和更新
* 运行 Ansible playbook
* 运行 shell 脚本（无需 SSH，控制台操作即可）  
  
Lab 步骤：  
1. 创建拥有相应 SSM 管理权限的 IAM role（此例 AmazonEC2RoleforSSM）
2. 开通一个 EC2 实例并赋予上面的 role 以及 Tag
3. 往 Systems Manager 控制台，Find Resources 里选择 EC2 实例并按 Tag 筛选，Query Results 里会返回相关实例列表（如果列表里有多个返回值，可以保存它们为一个分组以方便日后操作管理 - 比如对分组里所有实例执行某项命令）（Find Resources 搜索、分组的资源不一定必须 EC2 实例也可以是 S3 或其他资源）
4. 然后就可以在控制台左侧每个下拉菜单下点选选项卡进行各项管理：
    * Systems Manager 控制台的 Build-in Insights 选项卡，在这里可以选择上面的资源组以查看它们相关的 Config、CloudTrail、Personal Healthy Dashboard（相关的 AWS 服务本身的 operational issue 报告、事件、类似 AWS 的 status page）、Trusted Advisor（Recommended Actions - 安全、成本、服务限制、性能等等的建议）的信息等等
    * 库存（Inventory）选项卡，提供所有在 Systems Manager 注册过的你的 EC2 实例或 on-premises 本地数据中心、服务器的库存视角 View，比如使用最多的 OS 版本，应用、服务、管理的实例等等
    * 合规（Compliance）选项卡，合规总结：多少管理的实例合规打了补丁，多少管理的实例不合规未打补丁
    * Actions 下拉菜单下的自动化（Automation）选项卡可批量执行自动化任务（比如重启实例、资源备份等等）（该页面下方可在众多管理实例列表进行多选并最终点击批量执行任务）
    * 运行命令（Run Command）可以在不登录、SSH 实例的情况下，对一个或多个实例、资源运行命令（如安装应用、运行 Ansible playbook、自定义脚本程序等等），设置完命令后还可以设置 SQS 通知、输出写入 S3 bucket 等等后续操作
    * 补丁管理选项卡，对多个实例进行多种补丁操作
    * Maintenance Windows 选项卡，可设置周期性地运行命令、自动化、任务等等
    * Distributor 选项卡，可以给你自己开发的软件打包并部署到 Systems Manager 管理的所有实例上
    * 状态管理选项卡，比如对资源配置更新观察其执行状态
    * Activation 选项卡，管理 on-premises 的服务器、VM、实例、系统以及甚至树莓派设备等等（但是前提是都必须安装 System Manager SSM Agent - 连接 SSM 的中间人）（以及混合云环境管理，因此也能管理 AWS 的 EC2 实例）
    * Documents 选项卡，定义前面的自动化任务及命令的地方，你可以自己新建、自定义（JSON）  
  
可以把 AWS Systems Manager 当作管理员的中央控制管理平台。  
  
### AWS Systems Manager Parameter Store
场景：你在银行里做系统管理，你需要保存机密信息如用户、密码、许可证 Key 等等。这些信息需要传递给 EC2 实例比如进行一些启动脚本，但有用同时保证信息安全不外泄。因此 AWS Systems Manager Parameter Store 帮助你做到这点。  
AWS Systems Manager Parameter Store 没有自己的控制台，但是你可以在 EC2 的控制台找到它（Systems Manager Services 与 Systems Manager Shared Resources）。  
1. Systems Manager Shared Resources 选择 Parameter Store，此服务可以用于创建、保存、跨服务跨平台引用敏感信息（比如在自动化中引用敏感信息）。
2. 创建 Parameter，可以选择 Parameter 类型，有纯字符串、字符串数组不加密类型，还有 Secure String - 即应用 KMS 对数据自动进行加密/解密（因此使用时引用 Parameter Name 即类似程序里使用变量名即可，而该 Parameter 的数值只有创建者或权限者知道）。  
Systems Manager Parameter Store 支持的服务有：EC2、CloudFormation、Lambda、EC2 Run Command 等等。  
  
更多参考：https://docs.aws.amazon.com/zh_cn/systems-manager/latest/userguide/sysman-paramstore-working.html