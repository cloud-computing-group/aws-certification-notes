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

## Subnets, VPC Routers and Route Tables
### Subnet
子网是为了在 VPC 内创建隔离间，它是 VPC 的一个限制在单个 AZ 的 segment。  
当确定 VPC 的 CIDR 块区域时，需要考虑以下几点：  
1. 需要和其他 VPC 集成吗？（不能有 IP 地址重叠冲突）
2. 需要和 on-premise 网络集成吗？（不能有内网 IP 地址重叠冲突）
3. Plans for subnetting（VPC CIDR 块需根据你将对子网的分配来确定）
   1. 该 Region 有多少个 AZ？比如 3 个 AZ 就把 /16 的 VPC 分成 4 个 /18 的子网（留一个空闲子网因为该 Region 可能以后还会增加 AZ）
   2. 如果预估到你的应用在未来会增长到更多的 AZ，因此就可以分割成 8 个 /19 的子网
   3. 你的 VPC 以及每个 AZ 需要多少 Tiers？比如说有 3 个 Tiers：数据库 Tier（多个 RDS 实例）、Web Server Tier（一些 EC2 实例）和 Management Tier（一些 EC2 实例 的 subset）。如此可以分割成每个 AZ 6 个 /21 的子网。Tier 对 Network ACL 的使用（子网层面启用 allow/deny rule）也很重要。为了更好地实现颗粒度的 incoming/outgoing 控制，需要把小的子网们与 NACL 集成使用。

![](./Subnet%20Addressing%200.png)  
![](./Subnet%20Addressing%201.png)    

如果你的 VPC 需要和其他 VPC 通信，请不要使用 default VPC，因为 CIDR 块都是一样的。  
/ 16 通常是为大型规模的网络服务。  

### VPC Router
AKA implicit router  
是数据包离开 VPC 子网前首先到达的地方。由 AWS 托管，所以会高稳定可用。  
假设以下一个 VPC，两个 AZ 各 3 个子网（数据库、后台管理、应用服务器），图例的 AZ 的 CIDR 块只是展示该 AZ 里将创建的示例子网们的范围的概念而不是真的可以设置 AZ 的 CIDR（这里假设概念上我们希望 AZ 的 CIDR 掩码在 /18 的话，且子网若为 /21 且主机地址在 AZ 假设的主机地址范围内则可以有 8 个这样的子网）。  
![](./VPC%20Router.png)  

每个子网都有一个 VPC Router（也因此在 CIDR 为其预留了第 2 个 IP 地址 - 比如 10.0.64.1）  
这里需要注意的是 AWS 不支持在 VPC 内广播（所以为其预留了 CIDR 块的最后一个 IP 地址）  
每个子网都预留的 5 个 IP 地址，详细的预留细节如下：  
1. Network Address（第 0 位 - 第 1 个 IP 地址）
2. for VPC Router（第 1 位）
3. The IP address of the DNS Server（第 2 位）
4. for AWS future use（第 3 位）
5. Network broadcast address（最后 1 位 - 最后 1 个 IP 地址）
  
VPC Router 同时作为一个让子网与其他 VPC 组件（IGW、VGW、NATGW 等等）通信的中介。  
DHCP option sets 是 VPC 创建时默认创建的，默认的，DHCP 服务会自动为子网内每个服务、实例、组件分配合适的地址，并同时提供给这些实例予相关的 DNS 和默认网关（VPC Router）的地址。开发者可以自定义 DHCP 服务，以满足一些更复杂的 hybrid 网络场景。  

Route Table（Main Route Table）在 VPC 创建时会被默认创建。  
Route Table 里的 Destination，可以是 CIDR 块或 prefix list（VPC Gateway Endpoints）。  
Target 值可以是 VPC 组件如 IGW、NATGW、VGW、virtual gateway endpoints、VPC peers、elastic network interface 等等。第 1 个默认值 local 是默认的静态值，不可删除。  
Destination 和 Target 是一对键值对，意味着当 VPC 内的流量的目标 IP 地址为 Destination 的范围里时，将其传递到 Target 所指向的组件，等待组件去进一步处理。  
如果子网没有自定义 Route Table，会默认使用 VPC 的 Main Route Table。最佳实践是子网有自己的自定义 Route Table。  

![](./VPC%20Route%20and%20GWs.png)  
![](./VPC%20Route%20Conclude.png)  

可以将子网与特定路由表显式关联。否则，子网将与主路由表隐式关联。  
一个子网一次只能与一个路由表关联，但可以将多个子网与同一子网路由表关联。  
