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
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/default/Certifications/Associate/Sysops%20Administrator/Trouble%20Shooting%20Potential%20Autoscaling%20Issues.png)  
  
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
  
### （安全）Security - Compliance Frameworks
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
  
### （安全）DDoS
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
  
### （安全）AWS Marketplace Security Products
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
  
### （安全）Security & Logging
  
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
  
### AWS Hypervisors
Hypervisors（虚拟机监视器）又称 virtual machine monitor（VMM），是一种运行虚拟机的计算机软件、固件或硬件。运行 Hypervisors 的主机被称为 host machine，Hypervisors 管辖的每个虚拟机被称为 guest machine。  
长期以来，EC2 实例都是运行在 Xen Hypervisors 上的虚拟机。Xen Hypervisors 可以将 guest OS（操作系统）以 Paravirtualization（PV）（比如 Linux）或 Hardware Virtual Machine（HVM）（比如 Windows）运行。  
* PV 是一种更轻量级的虚拟化形式，通常、曾经速度更快（不过现在与 HVM 的速度差距也不大了）。  
    * PV guest 依赖于 Hypervisors 提供优先度操作的支持，因为这些 guest OS 没有 CPU 的高级访问。CPU 提供的优先级模型分 4 级 Rings 即 0-3，Ring 0 优先级最高而 Ring 3 最低，host OS 执行在 Ring 0，guest OS（在 AWS 上即 EC2 实例）运行在 Ring 1，应用程序执行在 Ring 3。
* HVM guests 是完全虚拟化的。在 Hypervisors 上的 VM 并不知道它们与其他 VM 共享处理时间。  
亚马逊建议使用 HVM，且 Windows 只能运行在 HVM 上，Linux 可以运行在 PV 和 HVM 上。  
  
一些实例如 C5 类型实例如今运行在 KVM 上，意味着现在不是所有的实例都是基于 Xen 了，目前 AWS 未正式宣布 Hypervisors 迁移计划，可以继续关注。  
  
#### Isolation
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/default/Certifications/Associate/Sysops%20Administrator/Hypervisors%20&%20Security%20Group%20etc%20Isolation.png)  
  
#### 对 Hypervisors 的访问
管理员若有访问管理面板（Hypervisors）业务需求，可以通过使用 MFA 获得访问 propose-built administration hosts 的权限。这些 administration hosts 是一些特别定制设计、配置、创建的系统，这些系统强化了对云管理面板（Hypervisors）的保护。所有这些访问都会被日志记录、审计。当管理员不再有访问管理面板的业务需要时，对这些 hosts 及相关系统的特权访问应被撤销。  
  
#### 对 Guest（EC2）的访问
虚拟化实例完全由你控制（比如通过 SSH），你对这些账号、服务、应用都拥有完整的 root 访问、管理、控制权限，AWS 没有任何权限访问你的实例或 guest OS。  
  
#### （安全）存储擦洗
硬件层面上，EBS 自动擦洗用户用过的每一个存储块，因此一个用户在 EBS 相关硬件上存储的数据不会在无意中暴露、泄漏给另一个用户，其机制是 Hypervisors 会把原来分配给某个用户的但如今不再属于、分配给该用户的存储块上的数据擦洗掉（设为 0）。在擦洗未完成前，存储块（硬件）都不会被放入可接受（重新）分配的存储池中。  
擦洗之后你也无法使用任何工具进行数据恢复（保护之前用户的数据）。  
RAM 存储也和上面一样，按机制擦洗以保护用户数据。  
  
### （安全）专用实例与专用主机
专用实例是跑在某个用户专用硬件上的 VPC 上的 EC2 实例。你的专用实例是在物理主机设备托管层面上与其他 AWS 用户的实例隔离的。  
专用实例可能与同一个 AWS 账号的其他非专用实例共享物理硬件。  
可以按需支付专用实例，相比之下，购买预留（reserved）实例可最高节省 70%，Spot 实例最高可节省 90%。  
  
可以同时使用专用主机与专用实例来运行 EC2 实例在你的专属物理设备上。相比专用实例，专用主机提供了实例是如何运行在物理设备的额外的控制与视界（比如网络端口、socket、处理器核等等），你可以持续的部署你的实例到同一个专属物理设备，因此，专用主机允许你更好地使用已有的软件许可证比如 VMWare、Oracle 许可证，又或者更好地解决企业合规问题、监管要求等等。  
https://aws.amazon.com/cn/ec2/dedicated-hosts/  
想服务开通专用主机，只需到 EC2 控制台 -> 点选左边选项卡 Dedicated Hosts -> Allocate Host -> 完成向导等等即可。  
专用实例则在一般的 EC2 实例服务开通向导里即可设置（Tenancy 选项）。  
  
专用实例与专用主机都使用专属的物理设备。  
专用实例按实例收费，专用主机按主机收费，两者都比普通实例贵，后者更贵。  
  
### Systems Manager EC2 Run Command
* 以管理员身份管理大量实例，以及 on-premise 的系统
* 针对大量实例执行自动化普通管理员任务和特设配置更新比如打补丁、安装软件、不登录的情况下连接新实例到 Windows 域等等  
这些可以通过 Systems Manager 或 EC2 控制台完成。  
实操时需要 IAM 的 Simple System Manager Role。  
可以在没有启用 Remote Desktop Protocol 的情况下完成一些任务。  
  
### （安全）Pre-signed URLs with S3
可以通过 CLI 或 SDK 实现。通过 Pre-signed URL 访问 S3 object。
1. 创建 IAM Role 给 EC2 完整的 S3 权限
2. 服务开通一个 EC2 实例，给予 Role，SSH 该实例
3. 在实例的终端用 AWS CLI 新建 S3 bucket，随便上传一个文本文件，该文件将有一个 S3 的地址映射（私有的非公开可访问）
4. 在实例的终端用 AWS CLI presign 该文件地址并赋予参数设定有效时间，终端会返回一个 pre-sign 地址（可公开访问，此时你可以将该地址发送给有需要的人，有效时间结束后该地址即自动作废），示例代码：`aws s3 presign s3://xxx/xxx.txt --expires-in 300`  
默认有效时间是 1 小时。  
  
### （安全）AWS Config With S3
对 S3 使用服务 AWS Config，比如 AWS Config 添加 Rule 监察 S3 bucket 是不是被错误设置成公共可读访问或公共可写访问，当合规性检查不通过时在 Config 控制台会显示、提醒，这在生产坏境中对安全尤其有用。  
Rules name:  
* s3-bucket-public-read-prohibited
* s3-bucket-public-write-prohibited  
  
### Inspector vs Trusted Advisor
两者相似、易混淆。  
Inspector 属于 `Security, Identity, & Compliance` 类服务，是自动检查漏洞、安全问题，生成安全报告，提高合规性的服务。  
Trusted Advisor 属于 `Management Tools` 类服务，虽然也有提高安全评估与优化建议（安全针对目标较宽泛，比如安全组、IAM、MFA、根用户等等），但更多关注优化成本、性能、容错等偏组织类管理类运行维护类领域的工作。  
  
### Instant（即刻）Encription
* Instant Encription
    * S3
* Encription with Migration
    * DynamoDB
    * RDS
    * EFS
    * EBS  
  
