# A Cloud Guru
  
## 什么是 Elasticache
云平台的（内存）缓存系统服务，用于提升应用性能，因为相比基于硬盘的数据库，可以从（内存）缓存系统更快地（仅亚毫秒延迟）获取信息、数据。（内存）缓存系统通常位于应用与数据库之间（适用于重复性的数据）。  
另外（内存）缓存系统还能有效减少数据库的负担。且特别适用于读操作更频繁且数据不频繁更改的数据库。  
  
## Elasticache 好处及用例
读操作更频繁的场景，如社交网络、游戏视频共享、Q&A页面等等。  
数据存于内存中，因此低延迟访问，提升了应用总体性能。  
也有益于计算繁重的负载场景，如推荐引擎。  
可用于存储 I/O 密集型数据库的查询结果或计算密集型计算机的输出结果，又或者 BI、Redshift 持续在数据库上进行 OLAP transactions（即对数据库造成大的读操作负荷）。  
安全并兼容（PCI/HIPAA）。  
  
## 2 种缓存软件选择
* Memcached：
    * 多线程
    * 广泛采用内存对象缓存系统
    * 没有 Multi-AZ capability
* Redis：
    * 开源的基于内存的键值数据库
    * 支持更复杂的数据结构，比如 sorted sets 和 lists
    * 支持主从 replication 机制以及 Multi-AZ 以实现跨 AZ 的冗余存储、备份（如果你想尽量保证不丢失数据，这是更好的选择）  
  
## 2 种缓存策略
* Lazy Loading - 只有需要时才加载数据到缓存里
    * 如果所需数据已在缓存里，Elasticache 返回该数据给应用
    * 如果所需数据不在缓存里或已过期了，Elasticache 返回空值，然后你的应用从数据库里获取数据并把该数据写入缓存中以便下次使用
    * 长处在于不加载不需要的数据，节点失效时已没关系 - 因为新的重启节点不过是失去一些初始化缓存数据而已，只对性能稍微影响不会丢失产品实际数据
    * 短处在于初始请求性能不理想，以及陈旧数据过多，因为不会根据数据库数据更新而自动更新缓存内的数据除非收到请求
* Write-Through - 每次数据库被写入数据时即增添、更新缓存的数据
    * 长处是缓存数据从不陈旧，用户获取数据时更快（相比 Lazy Loading 遭遇陈旧数据或空数据时的情况，更新过多造成的延迟比 Lazy Loading 多但用户相对能容忍这一点）
    * 短处在于每次数据库写入数据都写入缓存一次因而写负载较高且不一定用得上，旧节点如果失效了新节点缓存数据会一直为空直到数据库写入新数据（因此为了解决这个问题，迁移到新节点需要结合 Lazy Loading 和 Write-Through），如果大部分数据用不被读取的话实际上浪费大量资源  
  
Lazy Loading 与 TTL（Time To Live）：  
* 指定时间（XX 秒）从而指定键（数据）过期时间（即过期就认定为陈旧数据不再使用）
* Lazy Loading 视过期键（数据）为无效缓存数据，因此应用会从数据库获取数据并按顺序写入缓存中并使用新的 TTL
* 并不直接消除陈旧数据，但是有助于避免陈旧数据  
  
## DAX（DynamoDB Accelerator） 对比 Elasticache
两者都提供内存缓存服务，且都支持 DynamoDB，但是 DAX 只是用于优化 DynamoDB 的性能且只能支持、用于 DynamoDB 开发，而且 DAX 只支持 Write-Through 缓存策略、不支持任何其他缓存策略比如 Lazy Loading，Elasticache 除了可以支持 DynamoDB 还可以支持其他应用、服务比如 RDS。  
  
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
* 可处理负载至 90%。如果超出 90% 则应往集群中增添节点
  
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