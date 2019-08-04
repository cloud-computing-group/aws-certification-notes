## A Cloud Guru
  
### What
配置记录，该服务档案记录了你的 AWS 资源在不同时期、时间的状态数据（比如配置信息、关系、更新变动等）。AWS 平台 Admin 的管理工具，保证了安全性及治理。  
另外 Config 还提供了 AWS 资源的 Configuration Snapshot 以及资源合规性的自动化检查。  
这是基于 Region 的非 Global 服务，所以如果需要，则每一个 Region 要单独开通。  
AWS Config 把其所有信息、数据存储于 S3 bucket 以实现其功能的。  
应该只给予管理员相关的 AWS Config 的访问、操作的全部权限。  
CloudTrail 可以监控 Config（比如谁、何时停止了 Config 的 Record）。  
  
术语：  
* Configuration Items
    * 资源的 Point-in-time attributes（比如某个安全组的对外端口值）
* Configuration Snapshots
    * Config Items 的集合（按时检查你的配置 - 比如每 1、3、6、12、24 小时等等）
* Configuration Stream
    * 变更的 Config Items 的 stream
* Configuration History
    * 一段时间内的某个资源的 Config Items 的集合（比如查看 2 周前的安全组是什么样的）
* Configuration Recorder
    * Config 服务的 Configuration，记录、存储了 Config Items  
  
Recorder setup：  
* 账号的某个 Region 的日志配置
* 存储于 S3 中
* 提示 SNS  
  
Config 包括的信息：  
* 资源类型
* 资源 ID
* 合规性
* 时间线
    * 配置细节
    * 关系
    * 变更
    * CloudTrail 事件  
  
合规性检查：  
* 触发机制
    * 周期性
    * 当接收到 Configuration Snapshot（可过滤的）
* Managed Rule（AWS Config 标准 Rule）
    * 大概 40 个（当前数量）
    * 它们大部分是简单、基础的但也是基石的
  
### Why
* 合规审计
* 持续监控（比如监控 AWS 任意资源，一旦有更改或事件，则发送 SNS 提示）
* 持续评估（持续地预订、评估你的资源、安全分析）
* 故障排除（可根据选择时间、时期获取当时的资源状态）（与 CloudTrail 集成）
* 对遵守的监控（多账号、多地区数据监控）
* 管理更改（跟踪资源动向，比如权限的更改）
  
### AWS Config Lab
该服务按每个 Rule 收费（比如一个 Rule 可能会收取每个月 2 刀的费用）。
1. 选择监控本账号在本地区或全球资源
2. 选择日志、记录数据存放的 S3 bucket
3. SNS 提示是否开启
4. 创建/选择该 AWS Config 的 Role
5. Rule 设置（包括 Managed Rule 和 Custom Rule）
6. Review 并确定创建（完成后会重定向你到该 Config 的 Dashboard）  
一旦创建无法在控制台删除（但控制台可以 Turn Off 它），需 AWS CLI 删除。  
Config 需要 IAM 给予相关服务的 Read-Only 权限，才能对相关服务进行跟踪以及合规性检查等等操作。  
  
Config 接收到事件后可选择触发 Lambda 函数又或者设置一个周期性执行的 Lambda 函数去查看 Config、进行合规性检查，Lambda 函数使用 Rule（标准 Rule 由 AWS 提供，当前有大概 40 个）进行合规性检查，判断 Rule 是否 Broken，如果是，则发送 SNS 给 AWS 平台管理员进行后续人工跟进。  
  
更多：https://aws.amazon.com/cn/config/faq/  