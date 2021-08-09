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

## VPC Basic Networking Design
VPC 不能跨 Region，一个 VPC 只能在一个 Region。  
所以如果应用因需要部署在多个国家或 Region，则需要在那些不同的 Region 都开通至少一个 VPC。  

创建多个 VPC 并不是必须的，不要使架构产生不必要复杂的过度设计。  
如果应用或系统只需要一个 VPC（这是完全可能的），就只开通、使用一个 VPC 就好了。  
每一个 default VPC（每个 AWS Account 初始都会有一个，除非通过 Control Tower 创建 Account 并指定不创建 default VPC）都已为每一个 AZ 创建了一个 default 子网，同时该 VPC 也已创建了合适的 default 安全组、NACL、路由表和互联网网关。  
你也可以自己创建 VPC，因此你需要负责管理、维护该 VPC ，包括设计、实现以及集成其他网络（比如其他 Region 或其他 AWS Account 的 VPC、其他云供应商的网络空间、corporate 或 on-premise 数据中心）到该 VPC。同时你应该明白这些自定义设计创建的网络组件将关联的安全与合规性风险问题。自定义 VPC 的好处是其带来更多的灵活性，能让你获得更适合你业务的网络基础设施，又或更无缝结合你已有的网络基础设施。  
  
自定义 VPC 的初始工作：  
* VPC Name Tag
* CIDR 块（之后不能再改；一个合适的 CIDR 块非常重要！）
* Tenancy（之后不能再改；两个选择：default 或 dedicated - 所有该 VPC 里创建的资源都是 dedicated 模式，default Tenancy 创建的资源也可以选择 dedicated 或非 dedicated，所以 dedicated Tenancy 只是更严格一些满足一些合规性要求）

Default VPC  
![](./Default%20VPC.png)  
  
为何需要多个 AWS Account？  
对于大型企业或全球性/跨国的应用或系统，这是需要的，比如不同的 Team（甚至第三方）使用不同的 Account。  
如此每个 Account 就会有一个或多个 Region 及一个或多个 VPC，这些 VPC 还可能需要互相连接。除了这些 Account 之外，更复杂的一些情况可能还包括要连入、集成一些已有的传统的自己的企业数据中心。  
![](./Multiple%20VPCs.png)  
基于以上这些情况，当你一开始设计你的 AWS 网络基础设施以及 IP 寻址架构时，需要考虑、照顾到所有以上的情况、场景。  

AWS 网络设计问题比如 VPC 之间的集成问题往往都是 IP 地址范围设计错误带来的，所以自定义 VPC 的一开始的 CIDR 块范围决定非常重要。  

明白一个 CIDR 块有多少主机（减去 5 个预留主机）

3 步创建 VPC：CIDR 块范围选择，Tenancy 选择，关联 IPv6 范围（可选的，又因为 IPv4 与 IPv6 的 operation 是互相独立的，所以这两个地址家族的 VPC 的路由与网络安全组件也是分别配置的）。  

VPC IPv4 地址（必选）的 CIDR 的后缀可选范围：/16 - /28，可自己选择私有地址的 CIDR 块/范围，私有地址与公共地址不同  
VPC IPv6 地址（可选）的 CIDR 的后缀指定为：/56，不可以自己选择私有地址的 CIDR 块/范围因为 AWS 会分配，私有地址与公共地址相同，路由与安全政策控制安全  
VPC IPv6 数量还是受该 VPC IPv4 的数量限制的，因为后者是必选的并且被分配给 VPC 内开通的每一个资源（无论其是否需要在 communication 使用 IP）  

所有 default VPC 的 CIDR 块都是一样的，均为 172.31.0.0/16。  
一个安全组 associate 一个 VPC，但是可以 attach 到多个 EC2 实例。  
在 VPC 中启动实例时，可以为该实例最多分配 5 个安全组。系统对为每个 VPC 创建的安全组数、向每个安全组添加的规则数以及与网络接口关联的安全组数设有配额。  
