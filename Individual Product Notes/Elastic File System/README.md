## A Cloud Guru
  
### 什么是 Elastic File System（EFS）
通过 NFS（协议）安装的 Linux 弹性文件系统，灵活、可扩展、简单。  
  
### 特性
* AWS 完整管理无需维护
* 通过控制台、CLI、API 即可简单设置
* 安全 - 提供通过 at rest 或 in transit 的加密，加密钥匙由 KMS 提供
* 远程可用 - 通过 AWS Direct Connect 或 AWS VPN，你可以给你的 on-premise 设备、服务器安装 EFS
* 弹性 - 根据你的使用情况自动增长或缩小  
  
### 性能模式
有 2 种：  
* General Purpose - 默认，适用于对延迟敏感的场景（适用于如网页、CMS、Home directories）
* Max I/O - 可扩展增强吞吐量，但稍微有一点延迟（适用于如并行计算、大数据分析、视频处理）  
  
### 存储类别
有 2 种：  
* Standard - 默认，适用于频繁访问
* EFS IA - 适用于非频繁访问、长存数据但不常访问调用的，可有效降低存储费用的同时不影响高可用和弹性能力  
  
