## A Cloud Guru
EBS 即 attached 到 EC2 实例的虚拟硬盘（virtual disk）.  
大致有四种 Storage:  
1. General Purpose SSD（API name: gp2） - 适用于大部分场景如虚拟桌面，系统的boot volumes，运行低延迟交互应用，测试、沙盒环境，最大吞吐量率是 10000 IOPS。
2. Provisioned IOPS SSD（API name: io1） - 对 IOPS 有高要求或每个 volume 的吞吐量率高于 10000 IOPS 或 160 MiB/s 的场景，如大型数据库（MongoDB、Cassandra、Microsoft SQL）负载。
3. Throughput Optimized HDD（API name: st1） - 流负载同时要求高吞吐量率、一致性、低成本的场景，如大数据、数据仓库、日志处理，注意不可以用做系统 boot volume。
4. Cold HDD （API name: sc1）- 面向吞吐量的存储、低访问频率但存储大量数据的场景，如最低成本的文件服务器存储需求，注意不可以用做系统 boot volume。  
  
General Purpose SSD 每 GiB 的基础吞吐率为 3 IOPS，最大 Volume Size 是 16,384 GiB，最大总计吞吐量率为 10000 IOPS。  
General Purpose SSD 的 baseline performance 和 burst performance：比如有一个 1 GiB 的 volume，总计可达到 3 IOPS，但可以通过对该 volume 进行 burst performance 从而达到 3000 IOPS（burst = 3000 - 3 = 2997 IOPS，如果 volume 是 100 GiB，也是最高只可以到 3000 IOPS，那么此时 burst = 3000 - 300 = 2700 IOPS），这需要使用到 I/O Credits。无论 volume size 多大，burst IOPS 最高都是 3000 IOPS，因此如果 volume size 大于等于 1000 GiB 时即 baseline performance 大于 3000 IOPS 就没法 burst 了。  
I/O Credits：每个 volume 初始有 5,400,000 I/O credits 的 balance，足以维持最大 burst performance（3000 IOPS）持续30分钟，平时没有使用 burst 或超过 provisioned IO level 时就会积攒这个 I/Ocredits。  
EBS 新建时即可达到其本身最佳性能，这称之为 pre-warming，但是如果是从 snapshots 中唤醒原 EBS 的话则会需要一段时间才能达到原最佳性能，比如首次数据访问有 I/O 延迟，为避免此状况，可以在正式恢复唤醒一个 EBS volume 前提前唤醒并读取 volume 所有的 blocks。  
  
### EBS CloudWatch Metrics：  
* Metric VolumeReadOps：指定时间内总计的 I/O 读操作次数。  
* Metric VolumeWriteOps：指定时间内总计的 I/O 写操作次数。  
（应用场景：比如上面的平均读写操作次数（metric 的总计次数除以观察时间的总秒数）超过 10000 IOPS 的话，就应该考虑使用 Provisioned IOPS SSD 的 EBS 了。）  
* Metric VolumeQueueLength：指定时间内等待进行读写操作的请求数量。  
  
### Volume Status Checks：  
有四种状态：ok、warning（degraded）、impaired（stalled 或 not available）、insufficient-data.  
  
### Modifying EBS Volumes：  
如果已经 EBS volume 已经 attached 到 EC2 实例上，无论有没有 detach 实例都可以通过 console 或 command line 修改它（increase size、change type etc），并可以监控其更新进度。  
