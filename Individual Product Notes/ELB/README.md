## A Cloud Guru
### ELB 全称 Elastic Load Balancers，主要包括 3 种 Load Balancer:  
1. Application Load Balancer（HTTP / HTTPS 层面，OSI 第7层）（Content Base Routing - 即 HTTP Content、Headers，可以进行智能、高级路由请求设置比如发送特定请求到特定服务器上）
2. Network Load Balancer（TCP 层面，OSI 第4层，适用于要求 ultra high performance 或高RPS同时低延迟或需要 static IP 地址的场景）（Transport Layer，极低延迟、非常快、通常在产品环境中使用它 - 每秒可处理百万次请求，但也费用较高）
3. Classic Load Balancer（旧的 ELB 类型，OSI 第4层或第7层 - 基于场景，不能如 ALB 那般进行智能设置，未来可能被淘汰掉）  
注意：ELB 不是免费的，因此注意当一个 region 的 ELB 不再使用后请记得停掉，常见的一种情况是产品的部署转移到另一个 region，但忘记关停以前 region 的 ELB 并且用户在新 region 的 ELB 页面看不见前 region 的运行 ELB，导致无谓的支出。
  
### 创建、服务开通（provisioning）一个 ELB：  
0. CloudWatch 控制面板页面的 all metrics 列表的 AWS Namespaces 只有在本 Region 开通至少一个 ELB 才会有 ELB 的 metrics 显示，否则没有。
1. 首先在 EC2 服务 dashboard 中的 Load Balancer 选项卡及页面中点击创建 Load Balancer，配置 VPC、安全组及安全设置、health check（配置用以 ping 一个路径中的文件比如 /healthcheck.html，设置响应超时限制、health check 间隔时间/频率、unhealthy 阀值即 failing 次数、healthy 阀值即 succeed 次数）、加载的 EC2 实例。
2. SSH EC2 实例，安装 Apache 或其他 Server，在之前 healthy check 设置的对应路径下创建符合设置的文件（healthcheck.html），然后开启 Apache（或其他 server）并使其在后台持续运行。（ELB对其的 health check 过程是 ping 这个文件，并不需要读取文件内容作对比，只需要 Apache 返回 200 或非 4XX、5XX 的状态即可，health check 的用处在于一旦 ELB 发现该服务、实例状态是 unhealthy 的，就不再会把客户端请求分配给它除非它返回 healthy 状态）
3. 完成创建后点选该 ELB，其下方控制板的选项卡会有监控栏，即 CloudWatch 对该 ELB 的默认内置 metrics（如 unhealthy/healthy host 统计、平均延迟、请求数、HTTP 5XXs统计、后端连接错误等等，这些 metrics 现在也会出现、包括在 CloudWatch 的 all metrics 列表的 AWS Namespaces 里），切换到 Description 栏，往下拉会看到 Access Logs 默认是 disabled 的（因为不是必须的），点击配置存储该日志记录的 S3 桶且配置压缩并最终启动 Access Logs。
  
Route53 应该指向 ELB 的 DNS 地址而不是其 public IP 地址，因为该 IP 地址是会变动的。  
上面的 ELB 创建、设置只添加了单个 EC2 实例，实际情况中，当访客激增时单个实例无法应对，因此现实处理方式是添加/附加一个 Auto Scaling 组而不是指定的实例，具体步骤如下：  
1. [将负载均衡器附加到 Auto Scaling 组](https://docs.aws.amazon.com/zh_cn/autoscaling/ec2/userguide/attach-load-balancer-asg.html)
2. [向 Auto Scaling 组添加 Elastic Load Balancing 运行状况检查](https://docs.aws.amazon.com/zh_cn/autoscaling/ec2/userguide/as-add-elb-healthcheck.html)
3. [将具有扩展和负载均衡功能的应用程序扩展到其他可用区](https://docs.aws.amazon.com/zh_cn/autoscaling/ec2/userguide/as-add-availability-zone.html)
  
### 四种方法监控 ELB：  
1. CloudWatch Metrics
2. Access Logs - 查看谁访问了 ELB
3. Request Tracing - 只能用于 Application Load Balancer
4. CloudTrail Logs - 与 CloudWatch 的不同：CloudWatch 监控如资源或服务的性能数据；CloudTrail 监控如 AWS 平台自身 API 收到的请求、调用，如审计一般。  
  
### CloudWatch Metrics：  
ELB 推送 Load Balancers 以及你的 targets（比如 EC2 实例） 的 data points（比如 EC2 实例的 RAM Utilisation 数据） 到 CloudWatch，你因此可以看到这些数据的统计结果，比如查看指定时间内负载均衡内的 healthy target 的总数，每个 data point 都有一个时间戳和一个测量单位（非必有的）。  
  
### Access Logs：  
用于收集信息如向 ELB 发送的请求的记录（时间、客户端 IP 地址、延迟时间、请求路径、服务器响应等等），这些可以用于分析流量模型、故障排除等等，要注意的是这个日志可以积累到占据很大的存储空间。  
一个重要的应用情景，Access Logs 可以用作一些已经被删除的 EC2 实例的日志数据的备案处，比如某日促销访客激增导致 Auto Scaling 了一些 EC2 实例，其中一些响应报错导致一些客户操作没有正确执行，而在促销结束后 Auto Scaling 删除了那些临时实例导致再也无法访问那些实例的 Apache 服务器的日志，support 人员为了处理客户的 ticket，一个可行的方法就是去查看 S3 中相关的 Access Logs 的当日那些与被删实例相关的日志数据，从而为客户进行技术或业务的排错与支持。  
  
### Request Tracing：  
用于跟踪客户端对 target 或某服务的请求，负载均衡接收到客户请求后会在转发至 target 之前增添或更新 X-Amzn-Trace-Id header，任何在负载均衡和 target 之间的服务或应用程序也都可以增添或修改此 header。注意只有 Application Load Balancer 可以使用 Request Tracing。  
  
### CloudTrail：  
可用于收集 ELB API 的请求记录、数据（如 ELB 服务开通、healthy check 设置更改等等，具体信息包括请求来源如 IP 地址、时间等等），并以日志文件的形式存储于 S3 中。  
  
### Pre-Warming 你的负载均衡
假使你有一个电商网站，准备进行节日促销，流量预计将是平时的 10 倍，即极短时间内（如近乎垂直直线）巨量增加的流量可能会使你的 ELB 过载从而无法处理所有请求（如果是逐渐增加的流量则无论流量多大都可以用 ELB 的 Auto Scaling 解决），解决方法是联系 AWS 申请 ELB Pre-Warming。  
Pre-Warming 基于你预期的流量会配置 ELB 达到合适的 capacity 级别，申请 Pre——Warming 时 AWS 需要知道：1.开始与结束日期；2.预期的每秒请求次数；3.大致总请求量。  
  
### 负载均衡与 static IP 地址
* Application Load Balancer - 自动扩展以适应负载，但是会对客户端连接的 IP 地址有影响因为引入新的 ALB
* Network Load Balancer - 不会有 IP 问题因为在每个 subnet 里创建了 1 个稳定的 IP 地址，这使得防火墙规则简单了 - 客户端只需要启用访问每个 subnet 里的 IP 即可
* 不必二选一，可以两个同时用兼有二者优点 - 把 ALB 放在 NLB 后  
  
### ELB 错误信息
* CLB 和 ALB 默认成功响应为 200
* 不成功的请求响应会返回 4XX 或 5XX
* 4XX 为客户端错误 - 比如 URL 错误返回 404
* 5XX 为服务端错误  
  
### ELB CloudWatch Metrics
* ELB CloudWatch Metrics 推送 metrics 至 CloudWatch（其中包括负载均衡及其背后、后端的实例的信息）
* 帮助确定系统是否性能良好
* 可以创建一个 CloudWatch 警报以执行特定动作，比如如果 metrics 达到预设限定的阀值就发邮件给管理员
* Metrics 每 60 秒收集一次  
  
#### ELB CloudWatch Metrics - Overall Health
* BackendConnectionErrors - 与后端实例连接的失败次数
* HealthyHostCount - 注册的健康的实例数量
* UnHealthyHostCount - 注册的健康的实例数量
* HTTPCode_Backend_2XX,3XX,4XX,5XX  
  
#### ELB CloudWatch Metrics - Performance Metrics
* Latency - 注册实例的响应或连接所需要的秒数
* RequestCount - 在一段时间内（1 或 5 分钟）完成的请求或连接次数
* SurgeQueueLength - 待处理请求数量，最大队列值为 1024，满了之后额外的请求会被拒绝（只适用于 CLB）
* SpilloverCount - SurgeQueue 里满了之后被拒绝的请求数量（只适用于 CLB）（这个数字过高暗示了可能的性能问题，意味着可能需要扩展基础设施架构）  
  
  
  
## CSAA Test Notes:  
* Monitoring ELB: CloudWatch metrics, Access Logs, Request tracing, and CloudTrail Logs.
* ELB logs can be enabled and stored in S3, use SSE-S3 for encryption.
* ELB log analysis - Athena analyse S3 using SQL.
* ELB only works within a region.
* 504 error means the gateway has timed out. 