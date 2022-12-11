## A Cloud Guru
  
### 什么是 DynamoDB
它是快速、灵活的 NoSQL 数据库，提供稳定一致的、任何规模下都能达到只有毫秒级延迟的响应性能，支持 Document 和键值数据模型。它灵活的数据模型及稳定可靠的性能使得它适用于手机、Web、游戏、广告技术、IoT 及其他应用场景。  
它是无服务的，不能手动进行 Auto Scaling（自动的，但可以进行一些有限的策略、设置：https://docs.aws.amazon.com/zh_cn/amazondynamodb/latest/developerguide/AutoScaling.html ），因为该服务完全由 AWS 管理（它根据当前 WCU/RCU 性能与表中数据数量来判断管理底层资源、服务开通），并可以与 Lambda 函数很好地结合使用，非常适用于无服务架构的应用、开发。  
基于 region，非 global。（但是有 DynamoDB Global Table，设计为了解决 Region fail 的情况 - 自动同步备份数据并在主 region fail 时 promote 其他 region 以替代工作 cover disaster：https://docs.aws.amazon.com/zh_cn/amazondynamodb/latest/developerguide/GlobalTables.html ）  
  
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
* 文档数据，格式可以是 JSON、XML 或 HTML（https://zh.wikipedia.org/wiki/%E9%9D%A2%E5%90%91%E6%96%87%E6%AA%94%E7%9A%84%E6%95%B8%E6%93%9A%E5%BA%AB ）  
  
### 操作
* DynamoDB 基于主键来存储、获取数据
* 2 类主键：
    * Partition Key - 又称 Hash Key，唯一性的 Attribute（比如 User ID、Email 等等）
        * Partition Key 值会被输入进一个内部哈希函数，然后函数输出值决定存储该数据的 partition 或物理地址
        * 如果使用 Partition Key 当作主键，则不会有主键重复问题
        * 某 Partition Key 的 Item 上的所有数据（Attributes）在物理上存储在一起
    * Composite Key - （Partition Key + Sort Key）的组合
        * 比如同一个用户在论坛里发表多个信息
        * Composite Key 作为主键的话将由以下组成：
            * Partition Key - 如 User ID
            * Sort Key - 又称 Range Key / Range Attribute，如发帖的时间戳
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
* DynamoDB 与 Lambda 函数集成（通过 DynamoDB Stream 的 event）
* Kinesis Stream 输出数据到 DynamoDB  
  
### 其他
性能要求一般指定在 Table 上。  
与 SQL、关系数据库不同，Table 无需定义数据结构或 schema，因此十分灵活。   
  
### Scan & Query
Query 根据主键和独有的 attribute 值找寻 Table 中的 Item，返回该 Item 的所有 attributes。  
可以使用可选的 sort key 对返回结果筛选（比如搜寻特定范围时间戳的 Items）。  
默认情况下，query 操作返回所有 attributes，但你如果只想要特定的 attributes 你可以使用 ProjectExpression 参数。  
返回的数据总是按照 sort key 以 ASC 排序，如果想反序即 DESC 的话可以通过设置 ScanIndexForwardparameter 为 false 达到。  
默认 Query 是 Eventually Consistent 的，你需要显式地设置才能 Strongly Consistent。  
  
Scan 扫描 Table 的所有 Items，默认返回所有 Items。  
使用 ProjectExpression 参数可以筛选返回的 attributes。  
  
* Query 比 Scan 更高效
* Scan 扫描整个 Table，然后再进行筛选，从而进行了多余的步骤
* 随着 Table 增长变大，Scan 执行需要更长时间且可能会在一个大 Table 的一个操作里就用尽开通允许的吞吐量  
  
改善：  
* 设置一个小的 Page size（比如设置一个 Page size 返回 40 个 Item）（因为更少的读操作）可以减少一次 query 或 scan 的影响
* 相比之下多次数的小操作不会掐住、影响其他请求
* 尽量少使用 scan 操作，设计 Table 以更好地使用 Query、Get、BatchGetItem APIs
* 默认情况下，scan 操作顺序地处理数据（按每 1 MB 一次的顺序处理），一次可以 scan 一 partition
* 你可以配置 DynamoDB 以并行 scan，逻辑地将 Table 或索引分成多个分段且并行的扫描每个分段
* 如果你的 Table 或索引的读写负载已经很重时，最好避免并行扫描  
  
### 服务开通吞吐量
* 吞吐量按 Capacity Unit 为单位
* 当创建 Table 时，指定你需要的读 Capacity Unit 和写 Capacity Unit
* 1 * 写 Capacity Unit = 每秒 1 * 1 KB 写操作
* 1 * 读 Capacity Unit = （每秒 1 * 4 KB Strongly Consistent 读操作）或默认的（每秒 1 * 2 KB Eventually Consistent 读操作）
* 如果应用读写更大的 Items 就会消耗更多的 Capacity Units 即也会收取更多的费用  
  
### DynamoDB On-Demand Capacity
* 费用来自于读写存数据
* 有了 On-Demand 你无需指定需求
* DynamoDB 持续地根据你的应用行为来扩展、收缩
* 适用于不可预测工作负载
* 只按用付费（按请求付费）  
  
### DynamoDB Transactions
* ACID Transactions（Atomic、Consistent、Isolated、Durable）
* 在多个 Table 上读写多个 Items 且保证要不就全部成功完成所有操作要不就一个操作都不完成（比如银行需要对多个数据、表写操作时需要保证非全即无的更改），且全部操作在一个单独的 DynamoDB Transaction 里完成
* 在写入 Table 前先检查先决条件  
  
### DynamoDB TTL
* Time To Live attribute 定义了你的数据过期时间
* 过期时间用于删除数据
* 对删除不相关或老旧数据有好处
    * Session 数据
    * 事件日志
    * 临时数据
* 通过自动删除不再相关或有用的数据以减少费用
* 你可以为 Query 或 Scan 命令过滤掉过期的 Item  
  
可以通过点选 Table -> Action -> Manage TTL 以启用 TTL 功能（通过定义、映射 TTL attribute 到 Item 的某个 attribute）。  
  
### DynamoDB Streams
* 按时间排序的 Item 层级的变更（插入、更新、删除）
* （事件）日志被 at rest 加密并存储 24 小时（可以用来审计、归档、重执行 transaction 到不同的 Table、基于某个 Table 的变更触发事件并与无服务架构集成比如 Lambda 或实例）
* 使用专用 endpoint 访问
* 默认记录主键
* 数据的镜像可在任意变更之前以及之后被获取、保存  
  
处理 Stream：  
* 事件是实时记录的
* 应用可以根据事件内容执行动作
* Lambda 的事件源
* Lambda 会轮询 DynamoDB 的 Stream
* 基于 DynamoDB Stream 事件执行 Lambda 程序  
  
### Provisioned Throughput Exceeded & Exponential Backoff
* ProvisionedThroughputExceededException 出现于当你的请求频率高于服务开通的读写 Capacity
* SDK 会自动重试请求直到成功
* 如果不是使用 SDK，则可以
    * 减低请求频率
    * 使用 Exponential Backoff  
  
Exponential Backoff：  
* 网络中的许多组件（如网络 switch、DNS 服务、负载均衡等等）会因为过载发生错误
* 除了简单的重试，许多的 AWS SDK（比如 S3 bucket、CloudFormation、SES 等等）也都使用了 Exponential Backoff
* 逐步地在连续的重试过程中延长等待，比如 50ms、100ms、200ms，为了改善 flow 控制
* 如果 1 分钟后仍不成功，那么可能是你的请求大小超过了你的读写 Capacity 的吞吐量  
