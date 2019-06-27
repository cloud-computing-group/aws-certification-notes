# A Cloud Guru
  
## Mornitoring Elasticache
Elasticache consists of two engines:
* Memcached
* Redis
https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html  
https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/CacheMetrics.WhichShouldIMonitor.html  
  
4 个重要的监控数值：  
* CPU 使用率
* EngineCPUUtilization
* Swap Usage（交换区使用情况）
* Evictions（移出）
* Concurrent Connections（当前连接）
  
### CPU 使用率
Memcached：
* 多线程
* 可处理负载至 90%。如果超出 90% 则应往集群中增添节点。
  
Redis：
* 非多线程。Scale up 会在 CPU 使用率达到临界点（数值90 除以核数）时发生。
* 比方说，正在使用节点 cache.m1.xlarge（有 4 核），那么 CPU 使用率的临界点就是（90/4 或者说 22.5%）。
  
Exam Tip: 考试无需计算 Redis 的 CPU 使用率。
  
### Swap Usage
Swap Usage 就是有多少 Swap 文件被使用着。Swap 文件（或称 Paging 文件），是一块预留的硬盘存储空间，在计算机用光 RAM 时用作缓存的（在 RAM 内存释放后会把数据移回 RAM 中，速度上也因此减慢了）。预留的存储空间大小等于 RAM 本身的空间大小。
  
Memcached：  
* 大部分时候 Swap Usage 应该为 0 且不超过 50Mb。
* 如果超过 50Mb 应该提升参数 `memcached_connections_overhead`。
* `memcached_connections_overhead` 定义了预留给 Memcached connections 以及其他杂项的 Swap 存储空间。
* https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/ParameterGroups.Memcached.html
  
Redis：  
* 没有 Swap Usage 指标，使用 reserved-memory。

### 移出（Evictions）
Evictions 可以想象成公寓里的租户，比如现有空置公寓慢慢地会入住租户，最后所有公寓都住满了导致还有租户想入住但租不了。Evictions（移出）此时就会发生 - 因为系统没有空闲的存储空间，因此当一个新的 item 增添进来则一个旧的 item 必被移出。  
  
Memcached：
* 没有推荐设定。根据你的应用情况设置阈值。
* Scale Up（节点内增添内存）或 Scale Out（增添节点）。
  
Redis：
* 没有推荐设定。根据你的应用情况设置阈值。
* Scale Out（增添读从节点）
  
### 当前连接（Concurrent Connections）
Memcached & Redis：
* 没有推荐设定。根据你的应用情况设置阈值。
* 如果当前连接有大量且持续的流量激增，这意味着可能是真实的流量激增或此应用没有正确地释放连接。