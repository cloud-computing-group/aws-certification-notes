CSAA Test Notes:  
* Not for RDS scaling.
* Launch configurations: AMI ID, instance type, key pair, SGs, block device mapping, etc.
* Can send notification/alarm to recipient, and SNS topic. (few steps for metrics, launch/terminated, or failed to launch/terminited.)
* Up to 20 on-demand instances by default.
* Can scale based on the size of SQS.
* Register IP address with target group on ELB.
* Enable Cross-Zone load balancing for Application ELB.
