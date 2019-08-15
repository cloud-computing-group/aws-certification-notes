## A Cloud Guru
  
### Tags & Resource Group
什么是 Tags：  
* 附着在 AWS 资源上的键值对（比如给 EC2 实例一个别名）
* 元数据
* Tags（标签）有些时候可以继承
    * Auto Scaling、CloudFormation、Elastic Beanstalk 可以创建其他资源（即被服务开通的资源可以继承开通它们的比如 CloudFormation、Elastic Beanstalk 的标签）  
  
什么是资源组（Resource Group）：  
通过一个或多个标签，资源组可以让你更容易地对资源进行分组。  
资源组包括以下信息：  
* Region
* 名字
* Health Check  
特定信息：  
* 比如 EC2 - 公共 & 私有 IP 地址
* 比如 ELB - 端口配置
* 比如 RDS - 数据库引擎等等  
资源组有 2 种：  
* Classic Resource Groups - Global 的
* AWS Systems Manager - Region based 的  
创建 Classic 资源组时只需在 AWS 控制台右上角点击 Resource Groups -> 下拉列表点击 Create Classic Resource Groups 即可。  
创建 AWS Systems Manager 资源组则只需在 AWS 控制台右上角点击 Resource Groups -> 下拉列表点击 Create a Group 即可（其实是重定向到 AWS Systems Manager 控制台页面）。  
  
### EC2 启动错误
常见原因：  
* InstanceLimitExceeded 错误
    * 超过你在本 region 可以启动的实例
    * AWS 默认基本单一 region 实例启动限制设置（20 个），但你可以后期请求、设置提升限制
* InsufficientInstanceCapacity 错误
    * AWS 现时没有足够的 on-demand capacity 去满足你的请求（这是 AWS 地区数据中心资源不足的问题，较少出现）
        * 解决方法包括：等几分钟再重试、请求实例数量减少、换一个实例类型、试试 reserved 实例、不指定 AZ 等等  
  
### Bastion Host
* Bastion Host 是你的 public subnet（即 internet 可访问）的主机（solution architect associate 的 VPC 内容）
* 允许你通过 SSH 或 RDP 访问 EC2 实例
* 可以在你的本地电脑上通过 internet 登录 Bastion Host
* 然后可以使用 Bastion Host 来初始化一个在 private subnet SSH/RDP session 到 private subnet 的一个 EC2 实例，所以 Bastion Host 也被称为 jumpbox
* 这可以使你安全地管理你的 EC2 实例而且又不用将其暴露在互联网中，Bastion Host 设置限制指定特定 IP 可访问且特定端口可访问  
  
