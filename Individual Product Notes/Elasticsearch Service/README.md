## A Cloud Guru
  
### 什么是 Elasticsearch Service
Elasticsearch Service 是 AWS 托管管理 Elasticsearch 的平台、服务，可以让你更容易规模化地部署、安保、操作 Elasticsearch 并保证零 Down Time。  
  
### The ELK Stack
* Elasticsearch
    * 开源、RESTful、分布式搜索与分析引擎
    * 基于 Apache Lucene 构建
    * 高性能
* Logstash
    * 开源的数据撷取工具
    * 从不同的源收集数据，可使数据变形转形并发送至你希望的目的地
* Kibana
    * 开源的数据可视化与探索工具，用来观察日志与事件
    * 易使用的可交互图表，内置的聚合与过滤功能  
  
在 AWS 不需要手动开通这些服务，AWS 会为你代办。  
  
### 特性
* 开源 Elasticsearch API
* AWS 托管的 Kibana
* 可以和 Logstash 及其他 AWS 服务（比如 Kinesis Firehose、IoT、CloudWatch、KMS、IAM）集成
* 性价比高
* 容易扩展（控制台点击或通过 API）
* 高可用性（多 AZ 部署）
* 安全（KMS 管理控制 Key，由 Cognito 及 IAM Policies 还有 HIPAA、PCI、ISO 标准等等来管理控制 Authentication）  
  
### 更多：  
https://www.elastic.co/products/elasticsearch  
https://aws.amazon.com/cn/elasticsearch-service/the-elk-stack/  
