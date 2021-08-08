https://learn.acloud.guru/course/aws-networking-specialty/dashboard  
  
## Global 基础设施
**Regions**  
e.g.  
us-west-1  
us-west-2  
Region 之间完全独立  
  
还有个 GovCloud 是政府专用的（政府专用、或政府相关机构厂商使用）。  
  
企业或个人开发的应用的云基础设施，就是在 Region 里定义的。  
  
每个 Region 有 >=2 个的 AZ，每个 AZ 有 >=1 个的数据中心。  
所以 AZ 是数据中心的集合，不应简单地视为单个数据中心。  
AZ 之间的 connection 小于 2 毫秒，因此一个 AZ 宕机了可以迅速地把网络应用迁移到另一个 AZ，因此容错性（Fault Tolerance）较好。  
AZ 的名字比 Region 要多一个字母  
  
**Availability Zone**  
e.g.  
us-west-2a  
us-west-2b  
  
因此某个 Region 的 default VPC 的子网选项列表包含了每一个该 Region 的 AZ。  
不同的 Account 即使部署资源在同一个 AZ，其实际物理硬件的物理地址也可能是不一样的（原因：比如相比 us-west-2e 等等其他 AZ，us-west-2a 托管资源负载过大）。  
子网创建时要选择 AZ，子网一旦创建好后，其 AZ 不能再改。  
  
**Edge Location**  
i.e. AWS 的 CDN 服务 CloudFront。  
Edge Location 可以是一个或多个数据中心。  

用于客户的本地缓存，使得 content 部分延迟更低、响应更快、资源效率更高。  
  
https://aws.amazon.com/about-aws/global-infrastructure/regions_az/  
  
![](./AWS%20Global%20Infrastructure%20Architecture.png)  
