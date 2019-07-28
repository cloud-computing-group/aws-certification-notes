## Domain
* Collection（Kinesis、SQS、IoT、Data Pipeline）
* Storage（DynamoDB）
* Processing（EMR）
* Analysis（Redshift、Machine Learning）
* Visualization（QuickSight）
* Data Security
  
前期准备：  
在 AWS 上你需要一个大功率 EC2 实例（m5.large）并配备 100GB 的 root volume 进行大数据的 Lab 实验。  
一些前置要求准备的工具：SQL Workbench/J（免费，用于 Redshift），VPC（如 subnet）。  
生成 Dataset，需要下载 TPC-H 工具（benchmark）来生成 Dataset（创建一个大数据集并分割成多个 tbl 文件最后存入 S3 中）。  
流数据是什么？（https://aws.amazon.com/cn/streaming-data/）  
  
SQS VS Kinesis - 何时使用哪个：  
* SQS 使用场景  
    * 按顺序处理
    * 图片处理
* Kinesis 使用场景  
    * 快速处理日志与采集数据
    * 实时 metrics、报告
    * 实时数据分析
    * 复杂的流数据处理
    * 通常处理完发送给其他服务如 Redshift、DynamoDB、S3、Elastic Search
  
