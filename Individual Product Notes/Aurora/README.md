## A Cloud Guru
  
### 什么是 Aurora
AWS 自己开发的可兼容 MySQL 和 PostgreSQL 的数据库。  
性能好开销低。  
  
### Scaling
初始为 10 GB，每次 scale up 可增加 10 GB，最多 64 TB（Storage Autoscaling）。  
算力可 scale up 到 64vCPUs 以及内存 488 GiB。  
会有 2 个数据复制备份保存在每个 AZ，最少 3 个 AZ，即总共 6 份数据复制备份。  
  
可靠性：  
数据按每 10 GB 分割并分布在许多物理硬盘上。  
可以在 2 份数据备份丢失的情况下仍不影响写操作可用性，3 份数据备份丢失的情况下不影响读操作可用性。  
其物理存储层应用了自我修复检测机制，硬盘或数据块会被持续地扫描，一旦发现错误、故障就会自动修复、重启数据库。  
  
### Replicas
Aurora 现在有 2 种 replica：
* Aurora Replicas （目前最多可创建 15 个）- 与主数据库实例共享底层卷（因此 replica 都立刻可见主数据库的数据更新），对主数据库性能影响低，replica 数据库在主数据库宕机后立刻自动切换成主数据库且不会有数据丢失
* MySQL Read Replicas （目前最多可创建 15 个）- 对主数据库性能影响较高（replica 的数据是主数据库 replay 数据 transaction 过去的），replica 数据库在主数据库宕机后被自动切换成主数据库但可能最近几分钟的数据会丢失  
  
### 备份
* 自动地、持续地、增长性地备份数据
* 秒级 Point-to-time 还原
* 35 天保留周期
* 保存在 S3 上
* 对数据库性能无影响  

### 快照
* 用户初始化的快照存在 S3 上
* 一直保留直到你显式地删除它们
* 增长性地  
  
### Aurora 处于 CPU 100% 使用率
* 是因为写操作的话，scale up（提升实例属性）
* 是因为读操作的话，scale out - 创建、增添 Read Replicas  
  
### Aurora Serverless
这是一个按需、自动扩展的配置（MySQL 兼容版本），数据库会根据你的应用需要，自动地启动、关闭、scale up/down。  
你只需要按秒支付处于激活状态的数据库服务，通过 RDS 的控制台，你可以灵活的切换你的 Aurora 数据库至 standard 或 serverless 模式、配置。  
  
### Lab
应用编程时，写操作使用主数据库的 endpoint，读操作使用 Read Replicas 的 endpoint。  
Failover - 当 failover 时，RDS 会 promote 次高优先度 tier-1（最高优先度 tier-0 是主数据库）的 replica 为主数据库。  
Encryption at rest 是默认启用的，只要启用，其 Read Replicas 也自动启用。  
创建 Cross Region Replica 时会自动创建新的 Aurora 集群，最好选择 Multi-AZ 以保证高可用。集群不能被删除，但只要集群下的 Aurora 实例全部被删除则集群会自动删除自己。  
  
### 其他
Aurora 数据库实例创建必须在一个 VPC 内  
SSL（AES-256）被用于数据传输过程中加密