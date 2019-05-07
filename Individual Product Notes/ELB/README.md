### A Cloud Guru
ELB 全称 Elastic Load Balancers，主要包括 3 种 Load Balancer:  
1. Application Load Balancer
2. Network Load Balancer
3. Classic Load Balancer
  
  
  
CSAA Test Notes:  
* Monitoring ELB: CloudWatch metrics, Access Logs, Request tracing, and CloudTrail Logs.
* ELB logs can be enabled and stored in S3, use SSE-S3 for encryption.
* ELB log analysis - Athena analyse S3 using SQL.
* ELB only works within a region.
* 504 error means the gateway has timed out. 