## A Cloud Guru
  
### 什么是 Athena
* Athena 是一个交互式的查询服务，你可以通过它使用标准 SQL 来分析或查询 S3 上的数据
* 无服务架构（Serverless），无需服务开通，按每条查询、每 TB 扫描来付费
* 无需设置复杂的 ETL 处理
* 直接工作在 S3 上的数据上  
  
### 使用场景
* 可以用来查询存储在 S3 中的日志文件，如 ELB 日志、S3 访问日志等等
* 基于 S3 上的数据生成业务、商业报告
* 分析 AWS 成本和使用报告
* 对比如点击流数据执行查询操作  
  
### Lab
步骤：  
1. 设置 CloudTrail 存储 AWS 账号的事件、访问审计日志数据在 S3 bucket 上
2. 创建 Athena 数据库
3. 使用 Athena 查询 S3 bucket 上的数据  
  
本路径中的 txt 文件中的 SQL 命令可以在 Athena 控制台中执行（比如新建一个数据库）（注意我们的 txt 文件代码例子里的 `LOCATION` 至关重要因为它指定了查询的 S3 的地址）（txt 文件 Athena_Query_Create_Table 先预处理 S3 bucket 中的日志数据，然后生成一个数据库 table，此时再由 txt 文件 Athena_Query 来对 table 中的数据进行查询、操作即可）。  
PS：注意 Athena 在 AWS 中归类在 Analytics 下而不是 Database。  
  
## 官方文档
Athena 还可与 AWS Glue 数据目录进行开箱即用集成，让你能够跨各种服务创建统一的元数据存储库、抓取数据源以发现 schema 并使用新的和修改后的表与分区定义填充数据目录，以及维护 schema 版本控制。你还可以使用 Glue 完全托管的 ETL 功能来转换数据或将其转化为列格式，以优化成本并提高性能。  