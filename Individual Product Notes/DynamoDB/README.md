## A Cloud Guru
  
### 什么是 DynamoDB
它是快速、灵活的 NoSQL 数据库，提供稳定一致的、任何规模下都能达到只有毫秒级延迟的响应性能，支持 Document 和键值数据模型。它灵活的数据模型及稳定可靠的性能使得它适用于手机、Web、游戏、广告技术、IoT 及其他应用场景。  
它是无服务的，不能手动进行 Auto Scaling（自动的），因为该服务完全由 AWS 管理（它根据当前 WCU/RCU 性能与表中数据数量来判断管理底层资源、服务开通），并可以与 Lambda 函数很好地结合使用，非常适用于无服务架构的应用、开发。  
基于 region，非 global。  
  
### 特点
* 存储在 SSD 硬盘存储上
* 没有数据量存储限制
* Write Capacity Units（WCU）- 每秒 1 KB 块数量
* Read Capacity Units（RCU）- 每秒 4 KB 块数量
* 分布在 3 个不同的地理位置的数据中心（避免单点故障）
* 2 种数据一致性选择
    * Eventually Consistent Reads（默认）
    * Strongly Consistent Reads  
  
### 结构
* Tables
* Items（类比关系数据库的表中的行数据）
* Attributes（类比关系数据库表中的列数据）（不同的 Item 可能 Attribute 不同，比如 Item 1 有 Attribute 1 但 Attribute 2 为空，而 Item 2 有 Attribute 2 但 Attribute 1 为空）
    * 字符串
    * Number 类型
    * 二进制类型
    * 布尔类型
    * Null
    * Document（List / Map）：JSON
    * Set
* 支持键值和文档数据模型、结构
* 键 - 数据的名，值 - 数据本身
* 文档数据，格式可以是 JSON、XML 或 HTML（https://zh.wikipedia.org/wiki/%E9%9D%A2%E5%90%91%E6%96%87%E6%AA%94%E7%9A%84%E6%95%B8%E6%93%9A%E5%BA%AB）  
  
### 操作
* DynamoDB 基于主键来存储、获取数据
* 2 类主键：
    * Partition Key - 又称 Hash Key，唯一性的 Attribute（比如 User ID、Email 等等）
        * Partition Key 值会被输入进一个内部哈希函数，然后函数输出值决定存储该数据的 partition 或物理地址
        * 如果使用 Partition Key 当作主键，则不会有主键重复问题
    * Composite Key - （Partition Key + Sort Key）的组合
        * 比如同一个用户在论坛里发表多个信息
        * Composite Key 作为主键的话将由以下组成：
            * Partition Key - 如 User ID
            * Sort Key - 又称 Range Key，如发帖的时间戳
        * 不同的 Item 也许有相同的 Partition Key，但同时 Sort Key 就不可能相同
        * 所有有相同 Partition Key 的 Items 都存储在一起，然后按 Sort Key 值排序
        * 允许你存储多个有相同 Partition Key 的 Items  
  
### DynamoDB 访问控制
* 通过 IAM 管理其认证与访问控制
* 你可以创建一个 IAM User，并赋予其相关 DynamoDB 的权限
* 你可以创建一个 IAM Role，获取一个（临时）Access Keys 来访问、操作 DynamoDB
* 你可以使用特定 IAM Condition 来限制 User 只能访问属于他们自己的数据  
  
IAM Conditions 例子：  
* 想象一个手机游戏应用有百万用户
* 用户需要访问他们在每个游戏玩得的最高分数
* 访问必须限制从而他们不会错误读取其他人的数据
* 这可以通过添加一个 IAM Condition 到一个 IAM Policy 从而只允许用户访问 Partition Key 匹配 User ID 的 Items 数据  
  
### Lab
编程语言的 AWS SDK 包括了 DynamoDB 的相应编程语言的 API。  
AWS CLI 也可以对 DynamoDB 进行操作。  
  
### DynamoDB Index
在 SQL 数据库中，index 是一种可以允许你对指定列的数据执行更快速的查询的数据结构。你在 index 里选择包括、要查询的列，然后在 index（而不是整个数据库的数据集）上搜索。  
DynamoDB（虽然不是 SQL 数据库）也支持了 2 类 index 以帮助加速你的查询：  
1. Local Secondary Index
2. Global Secondary Index  
  
### DAX（DynamoDB Accelerator）
DAX 是一个完全由 AWS 管理的、集群化的内存缓存系统（类似 Elasticache），它专用于服务 DynamoDB。  
* 可帮助提升至 10X 的读操作性能
* 在每秒百万次请求的场景下可达到微秒级性能
* 适用于读操作频繁和突发巨量负载场景
* 适用案例比如拍卖应用、游戏应用和黑五促销的零售网站等等  
DAX 如何工作：  
* DAX 只支持 Write-Through 缓存策略（具体是什么请看 Elasticache 笔记）
* 允许你对你的 DynamoDB API 调用指向 DAX 集群（好让你先从缓存获取数据而不是数据库）
* 如果你的应用查询的数据在缓存中，DAX 会直接将数据返回给你的应用
* 如果数据不在缓存（DAX）中，DAX 会对 DynamoDB 执行一个 Eventually Consistent `GetItem` 操作
* 从 DAX 中获取数据也有助于减少 DynamoDB 本身的负荷
* 可能有助于减少 Provisioned Read Capacity（从而节省成本）  
不适用的场景：  
* 因为其使用 Eventually Consistent read only，不适用于那些要求 Strongly Consistent read 的应用
* 不适用于写入操作密集型的应用
* 没有太多读操作、需求的应用
* 不需要微秒级响应时间、性能的应用  
  
### 与其他服务集成
* DynamoDB 可以直接将数据复制给 Redshift
* EMR 的 Apache Hive 通过使用类 SQL 语言读取 DynamoDB 表内实时数据，复制数据到一个 S3 bucket 中或从 bucket 中读入数据进 DynamoDB，复制 DynamoDB 表到 HDFS 或反向操作，对 DynamoDB 进行 Join 操作
* 通过 Data Pipeline 启动 EMR 集群导出数据到一个 S3 bucket 中或从 bucket 中导入数据进 DynamoDB
* EC2 实例上的应用读取、写入 DynamoDB
* DynamoDB 与 Lambda 函数集成
* Kinesis Stream 输出数据到 DynamoDB  

