## CSAA Test Notes:  
* Not for RDS scaling.
* Launch configurations: AMI ID, instance type, key pair, SGs, block device mapping, etc.
* Can send notification/alarm to recipient, and SNS topic. (few steps for metrics, launch/terminated, or failed to launch/terminited.)
* Up to 20 on-demand instances by default.
* Can scale based on the size of SQS.
* Register IP address with target group on ELB.
* Enable Cross-Zone load balancing for Application ELB.
  
## Official
  
### Launch Configuration vs Launch Template
https://docs.aws.amazon.com/zh_cn/autoscaling/ec2/userguide/LaunchConfiguration.html  
https://docs.aws.amazon.com/zh_cn/autoscaling/ec2/userguide/LaunchTemplates.html  
Launch Template 更好因为可以版本控制，且能使用最新的 EC2 类型以及 Spot 实例等等。  
Auto Scaling 的 已有、已在用 Launch Configuration 不能更改，需创建一个新的 Launch Configuration 并更新到该 Auto Scaling 以完成配置更新。  
Launch Configuration 和 Launch Template 基本类似 - 都是为 Auto Scaling 配置，后者可以从前者生成。  
建议使用 Launch Template。  
