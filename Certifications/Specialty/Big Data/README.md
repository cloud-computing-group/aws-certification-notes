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
  
