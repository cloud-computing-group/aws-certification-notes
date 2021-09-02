# DevOps 与 SRE 异同
https://dzone.com/articles/devops-or-sre-differences-similarities-and-which-r  
https://www.kubernetes.org.cn/7508.html  

DevOps 的概念就是将开发与运维结合起来，定义系统的行为，并了解需要做些什么来弥合开发团队和运维团队之间的“鸿沟”。  
SRE 是“软件开发工程师开始承担运维人员的任务”。  
像 DevOps 一样，SRE 也会整合开发团队和运维团队，帮助他们熟悉另一个团队的工作和任务，同时使得整个应用程序生命周期具有可见性。  
DevOps 和 SRE 都倡导自动化和监视，其目标都是减少从开发到部署生产中的时间，同时又不影响代码或产品的质量。  

根据 Google 的说法，DevOps 和 SRE 之间的主要区别在于：DevOps 只是关心需要做什么，但 SRE 却谈到了如何可以做到。  

### 减少组织孤岛
通常组织结构复杂的的大型企业，有许多团队是独立工作。每个团队都将产品推向不同的方向，没有与公司的其他成员进行交流，因此，他们无法从整体上了解产品全局。这可能会在部署中的引发问题。  

### 接受故障
尽管 DevOps 的概念是在故障出现之前进行预防，但是不幸的是，我们无法避免故障。DevOps 通过将故障视为必然发生的事情。  

在 SRE 中，通过制定一个公式来统计故障。换句话说，SRE 希望没有太多错误或失败。  
该公式，用两个关键标识符来衡量：服务水平指标（Service Level Indicators，即SLIs）和服务水平目标（Service Level Objectives，即 SLOs）。  
SLIs 通过计算请求延迟，每秒请求的吞吐量、失败次数来衡量每个请求的失败。 SLOs 源表示 SLI 在一定时间内的成功。  

### 实施渐进式变革
DevOps 的目标也是如此，但要以渐进和可处理的方式进行。DevOps 和 SRE 都希望快速发展，SRE 强调在这样做的同时降低故障成本。  

### 工具化和自动化
自动化是 DevOps 和 SRE 的主要重点之一。DevOps 和 SRE 都鼓励尽可能增加工具和实现自动化，通过消除人为操作为开发人员和运维降低出错率。  

### 衡量一切
自动化工作流程需要不断监控。DevOps 和 SRE 团队都需要确保他们朝着正确的方向发展，并通过衡量一切来做到这一点。  
主要区别在于，SRE 围绕 "运维是软件问题（operations are a software problem）" 的概念展开，从而使他们定义了一些可用性度量方法。  
SRE 还确保公司中的每个人知道如何衡量可靠性，以及在出现故障时该怎么做。  

## 可靠意味着什么
上面，讨论了责任划分，接受失败以及衡量一切。现在需要一种方法来确保一切都确实能够正常运行并且可靠。换句话说，应该有一个统一的方法来测量每个级别的可靠性。  
SRE 通过 SLIs 和 SLOs 来衡量，DevOps 团队会衡量失败率以及一段时间内的成功率，并且两者通常都是使用不同的工具和方法来进行的。可靠性不仅与基础架构有关，而且也与应用程序质量，性能、安全性息息相关。  
问题可能在应用程序的不同方面发生，并且当发生故障时，我们需要拥有可靠的数据，来了解问题发生的原因。如果我们将数据细分，包括：  
* 堆栈信息
* 变量状态
* JVM 状态：线程，环境变量
* 相关日志语句（包括生产中的 DEBUG 和 TRACE）
* 事件分析（频率，失败率，部署，应用程序）

由于这些数据是至关重要的信息，因此我们必须确保它是可靠且可操作的。  

# DevOps 和 SRE 的区别

https://zhuanlan.zhihu.com/p/87598465  

## 工作内容不同
职责不同导致两个职位工作内容也不尽相同，这里将 DevOps 工程师和 SRE 工程师职能列举如下：  
* DevOps
  * 设定应用生命管理周期制度，扭转流程
  * 开发、管理 开发工程师 / QA 工程师使用 开发平台系统
  * 开发、管理 发布系统
  * 开发、选型、管理 监控、报警系统
  * 开发、管理 权限系统
  * 开发、选型、管理 CMBD
  * 管理变更
  * 管理故障
* SRE
  * 管理变更
  * 管理故障
  * 制定 SLA 服务标准
  * 开发、选型、管理 各类中间件
  * 开发、管理 分布式监控系统
  * 开发、管理 分布式追踪系统
  * 开发、管理 性能监控、探测系统（dtrace、火焰图）
  * 开发、选型、培训 性能调优工具

## 技能点
DevOps：  
* Operator 技能
  * Linux Basis
    * 基本命令操作
    * Linux FHS（Filesystem Hierarchy Standard 文件系统层次结构标准）
    * Linux 系统（差异、历史、标准、发展）
  * 脚本
    * Bash / Python
  * 基础服务
    * DHCP / NTP / DNS / SSH / iptables / LDAP / CMDB
  * 自动化工具
    * Fabric / Saltstack / Chef / Ansible
  * 基础监控工具
    * Zabbix / Nagios / Cacti
  * 虚拟化
    * KVM 管理 / XEN 管理 / vSphere 管理 / Docker
    * 容器编排 / Mesos / Kubernetes
  * 服务
    * Nginx / F5 / HAProxy / LVS 负载均衡
    * 常见中间件 Operate（启动、关闭、重启、扩容）
* Dev
  * 语言
    * Python
    * Go（可选）
    * Java（了解部署）
* 流程和理论
  * Application Life Cycle
  * 12 Factor
  * 微服务概念、部署、生命周期
  * CI 持续集成 / Jenkins / Pipeline / Git Repo Web Hook
  * CD 持续发布系统
* 基础设施
  * Git Repo / Gitlab / Github
  * Logstash / Flume 日志收集
  * 配置文件管理（应用、中间件等）
  * Nexus / JFrog / Pypi 包依赖管理
  * 面向 开发 / QA 开发环境管理系统
  * 线上权限分配系统
  * 监控报警系统
  * 基于 Fabric / Saltstack / Chef / Ansible 自动化工具开发

SRE：  
* 语言和工程实现
  * 深入理解开发语言（假设是 Java）
    * 业务部门使用开发框架
    * 并发、多线程和锁
    * 资源模型理解：网络、内存、CPU
    * 故障处理能力（分析瓶颈、熟悉相关工具、还原现场、提供方案）
  * 常见业务设计方案和陷阱（比如 Business Modeling，N+1、远程调用、不合理 DB 结构）
  * MySQL / Mongo OLTP 类型查询优化
  * 多种并发模型，以及相关 Scalable 设计
* 问题定位工具
  * 容量管理
  * Tracing 链路追踪
  * Metrics 度量工具
  * Logging 日志系统
* 运维架构能力
  * Linux 精通，理解 Linux 负载模型，资源模型
  * 熟悉常规中间件（MySQL Nginx Redis Mongo ZooKeeper 等），能够调优
  * Linux 网络调优，网络 IO 模型以及在语言里面实现
  * 资源编排系统（Mesos / Kubernetes）
* 理论
  * 容量规划方案
  * 熟悉分布式理论（Paxos / Raft / BigTable / MapReduce / Spanner 等），能够为场景决策合适方案
  * 性能模型（比如 Pxx 理解、Metrics、Dapper）
  * 资源模型（比如 Queuing Theory、负载方案、雪崩问题）
  * 资源编排系统（Mesos / Kurbernetes）
