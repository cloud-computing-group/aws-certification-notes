## A Cloud Guru
  
### 什么是 Storage Gateway
Storage Gateway 包含了一个 on-premise 的软件工具（Appliance），用来无缝、安全地连接、集成云平台存储到你的 on-premise IT 环境、设备。  
* Storage Gateway 虚拟 Appliance 安装在你的数据中心。
* 支持 VMware ESXi 和 Microsoft Hyper-v
* on-premise 系统无缝集成 AWS 存储，如 S3  
  
### Storage Gateway 类型
* File Gateway - NFS/SMB
    * 文件作为 object 存储在 S3 bucket 上
    * 使用 NFS 或 SMB mount point 访问
    * 对于你的 on-premise系统，它就像文件系统安装在 S3 上
    * 拥有 S3 的功能 - bucket policies、S3 版本控制、生命周期管理、replication 等等
    * 它是 on-premise存储的低成本替代品
* Volume Gateway（使用 iSCSI 协议访问存储）
    * Stored Volumes
        * 本地存储你的所有数据，只在 AWS 上备份
        * 因此访问整个数据集时延迟很低
        * 你需要准备存储的基础设施，因为所有数据将存在你的数据中心
        * Volume Gateway 提供了稳定的异步备份至云上，以 EBS 快照的形式存储在 S3 上
    * Cached Volumes
        * 使用 S3 当作你的主要存储地方，并本地缓存常用数据在 Storage Gateway 上
        * 你需要足够的存储空间以缓存常用数据
        * 对于缓存数据，应用仍获得低延迟性能，也节省了大量 on-premise 存储的开销
    * Tape Gateway（VTL）（是一个虚拟磁带程序库，通过 AWS Glacier 提供了低成本的数据归档服务）
        * 你无需准备你的 on-premise 磁带备份基础设施
        * 集成现有磁带备份基础设施，如 NetBackup、Backup Exec、Veeam 等等，通过 iSCSI 协议连接到 VTL
        * 数据存储在虚拟磁带即存储在 Glacier 上，通过 VTL 可以访问这些数据  
  
