## A Cloud Guru
  
### RDS Multi-AZ
备份 RDS 数据库到多个 AZ，这样如果单个 AZ 宕机，RDS 会检查到并更新私有 DNS 请求给备份的数据库的 endpoint，因此保证了整体系统稳定运行。  
这些全部（包括实时同步主数据库数据到备份数据库）可由 AWS、RDS 自动管理、执行，比如检查到事件如宕机甚至 AZ 故障都会自动执行迁移到备份上（大概仍会有 1 分钟 down time）而不需要管理员介入。  
Multi-AZ 部署使用 synchronous physical replication (MySQL, Oracle, PostgreSQL) 或 synchronous logical replication (SQL Server) 来保持备份数据库的数据与主数据库同步。  
  
Multi-AZ RDS 是用于灾难恢复的，不是用于提高性能的，不是 Scaling 方案。想提高性能的话应该使用 Read Replicas。  
  
#### Exam Tips
可以通过重启实例来模拟宕机，重启操作可通过 AWS Management Console 或 RebootDBInstance API 执行。  
  
### RDS Read Replicas
通过使用数据库引擎内置的 replication 功能实现 scale out，减缓数据库的读操作负荷。  
Read Replicas 是 Read-only 的。  
Replication 是异步的。  
  
可以通过 AWS 控制台或 CreateDBInstanceReadReplica API 启用此功能。为源、主数据库创建了 Read Replicas 数据库后，应用可以分布地在它们中间均匀读取数据。  
甚至可以给 Read Replicas 创建 Read Replicas（但是注意根据主数据库的数据复制、更新上的延迟）。  
Read Replicas 用于：  
* 减缓读操作时负载过大比如算力或 I/O 性能不足
* 在主数据库因为复制数据给 replicas 或按时维护所导致的 I/O 暂停或其他原因导致的主数据库不可用时，继续服务于读流量
* 业务报告或数据仓库场景 - 即业务、商业报告、BI 或数据仓库应用等需要对数据库数据进行大量读取时，应该读取自 Read Replicas 以免影响主数据库的性能、负荷  
  
#### 支持版本
MySQL、PostgreSQL、MariaDB、Aurora  
Aurora 使用基于 SSD 的虚拟化的专用于数据库负载场景的存储层，Aurora replicas 会使用与主数据库同一物理硬件的存储资源以减少成本及避免复制数据到其他物理节点上。  
  
#### 创建 Read Replicas
创建时，AWS 会创建一个数据库的快照（snapchat）。  
如果没启用 Multi-AZ，快照将从主数据库创建，主数据库会有大概 1 分钟的 I/O 占用。  
如果启用了 Multi-AZ，快照将从其他 AZ 的数据库创建，这将不发生上述的主数据库 I/O 占用情况。  
但是快照创建和自动备份不能基于 Read Replicas。  
  
#### 连接 Read Replicas
当新的 Read Replica 被创建，你可以通过新的 endpoint DNS 地址来连接它。  
  
#### Promote Read Replicas
你可以 promote 一个 Read Replica 为一个独立的可读亦可写的数据库，这样将会切断主数据库与该 replica 数据库原有的主从关系（即可能完全没关系、互相独立了）。  
  
#### Exam Tips
Read Replicas 也可以是 Multi-AZ 的。  
相关的 Key Metrics 是 REPLICA LAG。 
自动备份未被启用的话则无法创建 Read Replicas。   
RDS CLI 例子：`aws rds describe-db-instances --region`