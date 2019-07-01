## A Cloud Guru
CloudWatch 是 AWS 提供的监控服务， 可以监控 AWS 资源以及运行在 AWS 上的你的程序。  
包括并不限于以下：  
* Compute
    1. Autoscaling Groups
    2. Elastic Load Balancers
    3. Route53 Health Checks
* Storage & Content Delivery
    1. EBS Volumes
    2. Storage Gateways
    3. CloudFront
* Databases & Analytics
    1. DynamoDB
    2. Elasticache Nodes
    3. RDS Instances
    4. Elastic MapReduce Job Flows
    5. Redshift
* Other
    1. SNS Topics
    2. SQS Queues
    3. Opsworks
    4. CloudWatch Logs
    5. Estimated Changes on your AWS Bill

CloudWatch 默认提供的基本监控是对 EC2 的监控 - Host Level Metrics 包括：CPU（Utilization）、Network（Throughput）、Disk（IO，Overall Activity，默认情况不包括硬盘剩余空间这类数据）、Status Check（Health of EC2 Host & Instance） etc，对 EC2 的 metric 细粒度默认是每5分钟（或称密度，数据收集、更新、渲染间隔）。RAM Utilization 是自定义的 metric，只要不是上面四个或 EC2 Host & Instance以外的监控 metric 都是需要自定义的。  
  
### CloudWatch Metrics 保存多长时间？  
首先，可以通过 GetMetricStatistics API 获取 CloudWatch Metrics 数据。CloudWatch 里的 Log 数据可以想存多久就存多久，CloudWatch Log 默认时存储限期是无限期的，但你可以稍后更改它。任何已停掉的 EC2 或 ELB 实例的 Log 数据也都可以继续保留。  
大部分各服务的 metric 数据细粒度默认是每1分钟的，但也有3分钟的或5分钟的（standard monitoring），这是基于该服务的需要自身设定的。当想设置该服务 metric 为1分钟或2、3分钟这种较小的细粒度时，你需要启用（或者说turn on）detail monitoring，自定义的 metric 最小数据细粒度是1分钟。  
  
### CloudWatch Alarms：  
可以创建一个 Alarm 去监控任何 CloudWatch Metric，这可以是 EC2 CPU Utilization、ELB 延迟或你的 AWS 账单，你可以通过设置一个合适的阈值/临界值来触发此 Alarm，并可以设置任意 action（比如给你自己发送 SNS 通知、触发一个 lambda function 去更改你的 infrastructure）去响应此 Alarm 触发（比如本月账单超过10元），因此 CloudWatch 及其 Alarm 是个十分强大的工具。  
  
CloudWatch 不仅可以监控云上资源，还可以用于 on premise 的资源监控，你只需要下载安装 SSM Agent 和 CloudWatch Agent，就可以把自己本地数据中心的监控数据上传到 CloudWatch 的 Dashboard 上。  
  


### 为 EC2 实例自定义 CloudWatch Metric：  
首先需要通过 IAM 给该 EC2 实例附上一个 CloudWatch full access（实际不需要这么高权限）的 Role，如果该 EC2 实例是新建则增添 bootstrap shell/bash script（如果是已有实例可以自己 SSH 该实例）来下载安装 perl 语言及其相关包、重定向至 /home/ec2-user/ 并下载解压安装 AWS 官方 CloudWatchMonitoringScript 并最后在该实例后台持续/周期性运行该脚本即可（教程里是基于 Linux 环境并通过 crond 和 crontab 设置为每分钟执行一次脚本命令 put 数据到 CloudWatch）。（另外请确保该 EC2 实例的 Security、VPC 的 SSH、HTTP 配置机制符合此场景）  
  
  
  
### Metrics From Multiple Regions & Custom Dashboards
CloudWatch -> Dashboards -> Create new dashboard -> add / select widget type (then select metrics for the widget, widget can be renamed) -> save dashboard.  
add / select widget type (比如给 EC2 metrics 如 CPU（Utilization）、Network（Throughput）添加 Line Widgets, DynamoDB 的 metrics 如 provisioned write / read capacity units 添加 Number Widget)  
CloudWatch Dashboard 是 cross region 的、全球的，意味着哪个 Region 访问 dashboard 看到的都一样。但是 add widget 时选择 metrics 时所能看到的可选 metrics 会受到 region 的影响。  
Add widget 的话也可以在以下路径实现：CloudWatch -> Metrics -> select metrics -> Actions (top-right of console) -> add widget.  
  
#### Exam Tips:
CloudWatch - Dashboards are multi-region and can display any widget to any region. To add the widget, change to the region that you need and then add the widget to the dashboard.
  
### Create A Billing Alarm
无所谓哪个 region, 点击右上角账户名的下拉菜单里的 `My Billing Dashboard`，你会重定向到 billing 页面，并可直观看到你即将要付的账单、金额，同一页再往下看是 Alert & Notification，在这里可以设置 Billing 的自动提醒、警告（比如账单一旦超过自定义的阈值或免费资源套餐已用完时就即刻通过电子邮件提醒），还可以设置发送 PDF 发票、存储账单报告到 S3 bucket 里等等。

  
  
## CSAA Test Notes:  
* CloudWatch Logs help to aggregate, monitor and store logs itself (by installing agent on EC2)  
* Export to S3, stream to Lambda/ElasticSearch  
* CloudWatch Events help to respond to state changes in AWS resources.  
