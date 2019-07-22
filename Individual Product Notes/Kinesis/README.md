### Kinesis
AWS Kinesis 是让你上传、输入流数据的 AWS 平台、服务，它让你更容易加载、分析这些流数据，并方便你开发符合你商业需求的自定义应用。
有三部分：
1. Kinesis Stream - 实时处理（如读取、转发、动态改变策略、启动警报等等）大量流数据，可用于实时的数据分析、实时的报告、复杂的交叉的流数据分析等等，支持多应用并行读取。
2. Kinesis Analytics - 实时地以 SQL 分析流数据。
3. Kinesis Firehose - 加载流数据到服务（比如 redshift）里  
  
### Kinesis Stream
由 Producer（KPL） & Consumer（KCL）组成。Kinesis Stream 还支持 Agent 和 API。上传至上面的流数据记录会保存在多个 Shard 中并默认会保留 7 天（24 小时）。  
Producer 是数据生产源（可以是比如联网设备、手机、EC2 实例等等）。Consumer 可以是比如 EC2 实例及其应用程序，它们从 Shard 中取数据并分析、转换成一些有用的分析结果或其他数据，最后把这些结果数据保存、发送至其他服务或平台上 - DynamoDB、S3、EMR、Redshift等等。
* Kinesis Stream 包含多个 Shards
    * 一个 Shard：每秒 5 个读操作，最高数据量读限制为每秒 2 MB，以及每秒 1000 条记录的写操作、最高数据量写限制为每秒 1 MB（包括 partition keys）。
    * 你的 Stream 总数据吞吐效率、能力取决于你给你的 Kinesis Stream 开通、设置的 Shard 数量。  
  
### Kinesis Firehose
也有 Producer，和上面的 Producer 一样，但全自动（无需担心 Shard 比如分配数据到不同的 Shard 以及数据量上升时手动开通更多 Shard、也无需担心 partition keys 等等因为皆全自动）没有 Consumer（可以设置 Lambda 函数或 Kinesis Analytics 做一些实时分析，但都是可选的），并最后直接将流数据或结果数据存入 S3 或 Elasticsearch Cluster 中（也可以最终发送至 Redshift，但是中间必须先途径 S3），保留时间默认为 24 小时（没必要保留太长时间因为一般此应用场景都是为了把上传的流数据直接写入 S3 等服务中，但也可以设置提高到 7 天）。  
  
### Kinesis Analytics
允许在 Kinesis Stream 或 Kinesis Firehose 保存的流数据上运行 SQL 语句，然后存储结果数据至 S3、Redshift、Elasticsearch Cluster 等等。  
  
### 什么是流数据
流数据是有成千上万个数据源持续生成的数据，通常是同时发送的 KB 级小体量的数据、记录。  
例子：  
* 电商网站产品购买记录、交易记录
* 股票价格
* 游戏数据（比如玩家操作数据）
* 社交网络数据（用户状态更新）
* 地理位置数据（比如 Uber）
* IoT 传感器数据  
  
### Lab
可以使用 CloudFormation 开通、配置 Kinesis 的服务。  
可本文件路径下的 CloudFormation 模版创建 stack（包括一个 EC2 实例用于 Producer 随机数据生成程序和 Consumer 分析程序的运行，一个 Kinesis Stream 实例 - 两个 Shards，两个 DynamoDB Table 用于最终结果数据存放 - 其中一个实时不断存入、新增 index.html 文件 - 即可能是可视化的网站的实际 html 文件源），stack outputs 的 URL 就是创建的 Kinesis 模版应用的可视化网站地址。  
要删除以上所有资源服务只需简单地删除 CloudFormation 的相关 stack 即可。  