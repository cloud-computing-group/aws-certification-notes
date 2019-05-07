CSA Test Notes:  
* 5 VPC are allowed by default.
* Cannot enable peered VPC unless is in the same account, cannot tag a log, cannot change config.
* Not monitored: traffic to DNS, generate by Windows instance, traffic from metadata, DHCP traffic, traffic to reserved IP.
* Application load balancer must be deployed into at least two subnets.
* Not allow perform scan on VPC without alerting AWS.
* NAT gateway - automatically assigned public IP, scale up to 10 GB, not in SG (NAT instance is).
* VPC flow logs is stored in CloudWatch logs - VPC/Subnet/Network Interface levels.