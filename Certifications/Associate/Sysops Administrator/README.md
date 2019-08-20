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
  
### Elasticity & Scalability
Elasticity - Scale with Demand（短期方案）  
Scalability - Scale Out Infrastructure（长期方案）  
举例 EC2：  
* Elasticity - 通过 Auto Scaling 增加实例数量
* Scalability - 增加实例本身的性能、容量、算力，又或者使用 reserved 实例  
注：RDS 没有 Elasticity 但是 Aurora 有（Aurora Serverless）  
  
### Trouble Shooting Potential Autoscaling Issues
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/master/Certifications/Associate/Sysops%20Administrator/Trouble%20Shooting%20Potential%20Autoscaling%20Issues.png)  
  
### Encryption & Downtime
对于大部分 AWS 资源，加密只能在创建时启用。  
* EFS（Elastic File System） - 如果你想加密已有的 EFS，你需要新建一个加密的 EFS，然后再把旧的 EFS 的数据迁移过去
* RDS - 如果你想加密已有的 RDS 数据库，你需要创建一个新的 RDS 数据库然后再把旧数据库的数据迁移过去
* EBS - 加密也是必须在创建时才能启用
    * 你不能加密一个未加密的 volume，或解密一个已加密的 volume
    * 你可以在加密和未加密的 volume 之间迁移数据（比如使用 rsync 或 Robocopy）
    * 如果你想加密一个已存在的 volume，你可以创建一个快照，复制该快照时启用加密从而获得加密快照，然后 restore 这个加密快照给一个新的加密 volume
* S3 - 任何时候都可以加密
    * S3 buckets 或单独的一个 object 在任何时候都可以加密，无需创建时就加密可之后再加密，且启用加密不会对应用、性能带来任何影响  
  
### Security - Compliance Frameworks
以下是 3 大安全标准、机构：  
* PCI
    * 全称 The Payment Card Industry Data Security Standard（PCI DSS）是广泛接受的用于优化信用卡、借记卡、现金卡交易的安全性的政策与程序，也保护了持卡者个人信息不被误用
    * 虽然 AWS 是 PCI 合规的，但是这不意味着你在 AWS 上的应用就是合规的，必须按 PCI 规定开发、检测应用，最后由 PCI 顾问检查过才能申请 PCI 合规
    * 建立、维护一个安全网络与系统，保护持卡人数据，维护漏洞管理，实现强访问控制方式，定期监控、测试网络，维护一个信息安全政策
        * 要求1：安装和维护防火墙配置以保护持卡人信息（比如 AWS 安全组等等）
        * 要求2：不要使用供应商提供的系统默认密码或其他与安全相关的默认参数
        * 要求3：保护保存的持卡人数据
        * 要求4：当需要在公开网络中传递持卡人数据时，必须使用传输加密（SSL）
        * 要求5：保护所有系统免于木马，并定期更新杀毒软件、程序
        * 要求6：开发和维护安全系统与应用
        * 要求7：按业务需要限制、开放访问持卡人数据
        * 要求8：认证和授权访问系统不同组件
        * 要求9：限制物理访问持卡人数据（比如旧硬件可能需要复制打印卡信息）
        * 要求10：跟踪和监控对网络资源、持卡人数据的所有访问记录（比如使用 CloudTrail 等等）
        * 要求11：定期测试安全系统和流程
        * 要求12：维护一个政策以解决个人信息的信息安全
* ISO
    * ISO/IEC 27001:2005 指示了如何根据组织的整体业务风险情况来建立、实现、操作、监控、复查、维护、提升一个文件信息安全管理系统
    * 比如当你的企业成长时，你所使用的 AWS 服务、资源的种类和数量也会增加，所以需要在文件信息安全管理系统的框架、标准下使用、开通这些 AWS 服务、资源
* HIPPA
    * HIPPA 是 1996 年建立的联邦健康保险可移植性和问责制法案，其主要目的是让民众更容易拥有健康保险、保障健康信息的安全和可信任，也帮助健康产业机构、厂商控制这方面的管理成本
    * 尽管 AWS 许多服务已是 HIPPA 合规的，但还有一部分 AWS 服务是未达到 HIPPA 合规的  
另外还有这些标准、框架：  
* FedRAMP
    * 全称 The Federal Risk and Authorization Management Program（适用于美国公司，政府程序），提供了标准方法来进行安全评估、认证及持续监控云产品、服务
* NIST
    * National Institute of Standards and Technology（美国） - 目的在于提高要害基础设施的网络安全，是一系列工业标准和最佳实践，用来帮助企业、机构管理网络安全风险
* SAS70
    * Statement on Auditing Standards No.70
* SOC1
    * Service Organization Controls - 会计标准
* FISMA
    * Federal Information Security Modernization 法案
如果你需要考 AWS 安全认证专家，还需要知道以下标准、规范：  
* FIPS 140-2
    * 是美国政府计算机安全标准，用来评估加密模块（如硬件安全模块）
    * 评分由级别 1 到级别 4，级别 4 是最高安全级别，CloudHSM 则达到了级别 3  
  
更多参考：https://aws.amazon.com/cn/compliance/  
  
### DDoS
资料：https://d1.awsstatic.com/whitepapers/Security/DDoS_White_Paper.pdf  
  
#### 什么是 DDoS 攻击
Distributed Denial of Service（DDoS）攻击是一种企图使你的网页应用最终对用户不可用、不可访问的攻击。  
有几种机制可以达到这点，比如大量的网络数据包洪水，并且可以结合反射放大攻击技术（Amplification/Reflection Attacks），又或者结合僵尸网络。  
  
#### 反射放大攻击（Amplification/Reflection Attacks）
反射放大攻击包括如 NTP、SSDP、DNS、Chargen、SNMP 攻击等等，即攻击者会给一个第三方服务器（比如 NTP 服务器）发送一个请求并携带一个欺骗的 IP 地址（攻击目标 IP 地址），该服务器就会响应该请求并携带一个较初始请求大得多的 payload（通常是初始请求的 28*54 倍）发送给攻击目标的 IP。  
这意味着如果攻击者发送一个 64 字节的携带欺骗 IP 地址的初始请求，NTP 服务器就会响应一个最高到达 3456 字节的流量。攻击者可以基于此并利用多个 NTP 服务器 1 秒钟以发送合法 NTP 流量到目标地址。  
  
#### 如何减轻 DDoS
* 减小攻击面积（比如使用 ALB 和网络应用防火墙）
* 可以 scale up 来吸收攻击（比如 Auto Scaling）
* 保障公开的资源
* 学习正常、日常行为（可以察觉非正常行为）
* 建立一个防御攻击的计划  
  
以下技术及服务都可以帮助防御 DDoS：  
* CloudFront
* Route53
* ELB
* WAFs
* AWS Shield
* Auto Scaling（同时使用 WAFs 和 Web Servers）
* CloudWatch  
  
### AWS Marketplace Security Products
* Kali Linux  
    * Kali Linux 是基于 Debian 的 Linux 发行版，设计用于数字鉴识和渗透测试，它是行业标准
    * 可以在 Marketplace 购买此产品，并用它服务开通 EC2 实例  
  
AWS 安全服务之一 - 漏洞与渗透测试：  
进行此测试前要求先向 AWS 申请权限（在 Marketplace 买了安全产品并不等于已有权限，仍需申请），然后需要填表。  
  
* Marketplace 上购买第三方供应商的安全产品
* 如防火墙、强化操作系统、WAFs、杀毒软件、安全监控等等
* 可以是免费的，按小时、月、年收费的或是使用你已有的许可证的
* CIS OS 强化  
在基于场景需求下，设计、实现安全解决方案时，Marketplace 及其安全产品会是一个不错的选项。  
  
课外知识：https://www.onlinehashcrack.com/  
  
### Security & Logging
  
#### Logging in AWS
服务：  
* AWS CouldTrail
* AWS Config
* AWS CloudWatch Logs
* VPC Flow Logs  
  
#### Logging
参考资源：  
* 白皮书：https://d0.awsstatic.com/whitepapers/compliance/AWS_Security_at_Scale_Logging_in_AWS_Whitepaper.pdf
* 开发使用、参考
    * ISO 27001:2005
    * PCI DSS v2.0
    * FedRAMP
* 查看 "Common logging requirements"  
  
#### 控制对日志文件的访问
* 避免非认证的访问
    * IAM Users、Groups、Roles、Policies
    * S3 bucket policies
    * MFA
* 确保基于 Role 的访问
    * IAM Users、Groups、Roles、Policies
    * S3 bucket policies  
  
#### 当日志被创建且配置错误时发出警报
* 当日志文件创建或失败时发出警报
    * CloudTrail notification
    * AWS Config Rule
* 警报需具体但切勿泄漏细节
    * CloudTrail SNS notification 只提及日志文件地址  
  
#### 管理 AWS 资源和日志文件的更改
* 日志记录系统组件的变更
    * （AWS Config Rule）
    * CloudTrail
* 控制以防止已有的日志变更
    * IAM 和 S3 控制与 policies
    * CloudTrail 日志文件验证
    * CloudTrail 日志文件加密  
  
