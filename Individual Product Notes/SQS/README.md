## A Cloud Guru
  
### 什么是 SQS
一个可以提供消息队列（Message Queue - 存放 Message 并等待算力、计算机处理它们）的服务。  
SQS 是一个分布式队列系统，允许 web 应用快速、稳定地生成消息队列，并且一个应用生成的消息将是另一个应用需要消费的消息。一个队列就是一个临时的消息集散仓库，里面的消息均等待被处理、消费。  
SQS 是一个 pull base 系统，SNS 是一个 push base 系统。使用消息队列的一个好处是你不会因服务器宕机失去要处理的信息（使用它的一个原因是出于考虑使用场景可能有容错要求），因为待处理消息会保存在在池子里一段时间（只要不超过 timeout 时间）。  
SQS 可以帮助解耦应用的组件并使它们能独立运行，更方便地管理组件间的消息使用、传递。分布式应用的任何组件均可往 SQS 里写入消息（支持多个读组件和多个写组件，且一个队列可被多个组件共享），每个消息最多可以保存 256 KB 的任意格式的文本数据（大于 256 KB 的话可以使用 SQS Extended Client Library 管理，该库将利用 S3 保存数据以实现），应用组件通过 AWS SQS API 以编程化pull、获取 SQS 消息。  
队列如缓存存储数据一般处在应用的各个组件之间，意味着队列可以解决一些常见问题比如生产消息的 producer 速度过快但消费消息的 consumer 速度过慢、又或者 producer 与 consumer 断断续续地连接到应用网络中。  
SQS 的队列是 region 的。  
  
### Queue 类型
* Standard Queues（默认）- transaction 每秒几乎无的数量限制，保证消息至少被传递一次，有时消息可能会被重复传递且传递顺序会有违输入顺序（因为高分布式架构的高吞吐量），但基本上该类型还是尽量使消息按被输入的顺序传递进、出 SQS（但不保证）。
* FIFO Queues（先进先出）- 与上面顺序可能失序不同，FIFO 保证了消息的传递顺序严格依照其输入顺序，消息仅被传递一次不重复且会持续可见直到 consumer 处理完并删除它。同时 FIFO 支持在一个队列里有多个排序消息组。该类型吞吐量限制为 300 transaction per second（TPS），其他特性与能力与 Standard Queues 一致。（适用于比如银行等对交易信息敏感、对准确性高要求的严格系统、场景）  
  
### SQS Key Facts
* 消息可以存放 1 分钟到 14 天
* 消息的默认保留时间为 4 天
* 保证消息至少会被处理一次
  
### SQS Visibility Timeout
是消息在 SQS 里被 consumer pick up 后不可见的时间，如果在 visibility timeout 时间内处理完该消息，消息就会从队列中删除，否则消息会再次可见于队列中并被其他 consumer/reader 处理，因此这可能会造成同一消息被处理两次。  
* 默认的 visibility timeout 时间是 30 秒
* 如果你的 consumer 任务处理时间超过 30 秒则应该提高 visibility timeout 的时间
* visibility timeout 最大时间是 12 小时  
  
### SQS 长轮询（Long Polling）
* SQS 长轮询可以让你从 SQS 队列中获取消息
* 与短轮询每次就返回轮询结果（可能有新消息或没有消息为空）不同，长轮询会一直等待到监察到有新消息或长轮询 time out 时间到了才会返回结果
* 长轮询比短轮询更便宜成本更低
  
### 更多
AWS 应用案例模型：  
1. SQS 不支持优先机制，但你可以通过服务开通两个或多个队列来实现（比如 consumer 应用优先拉取队列 1 ，若无新消息才拉取队列 2 中的消息）。  
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/default/Individual%20Product%20Notes/SQS/SQS%20Priority.png)
  
2. 应用前端等待用户上传图片与字符串，图片上传至 S3 后触发 Lambda 函数（或者也可以是 EC2 实例与前端合作的后端）把相关数据（字符串、图片所在 S3 bucket 地址、其他比如处理动作信息）输入到 SQS 中，一个持续运行 EC2 实例不断拉取 SQS 的消息一旦获取到消息则开始进行处理，最终 EC2 实例从 S3 中获取该图片并用字符串给图片打上水印并存放回 S3 中或返回给用户。  
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/default/Individual%20Product%20Notes/SQS/SQS%20Usage%20Example.png)
  
3. Fanout 结构执行并行处理逻辑，这里需要多个 SQS 队列订阅同一个 SQS topic 以实现。  
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/default/Individual%20Product%20Notes/SQS/SQS%20Fanout.png)
  
注：可以把 SQS 和 Auto Scaling Group 集成并由 ASG 监控（比如如果 SQS 消息过多 ASG 服务开通更多的 EC2 实例去处理 SQS 中的消息）。