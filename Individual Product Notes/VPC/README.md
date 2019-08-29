## CSAA Test Notes:  
* 5 VPC are allowed by default.
* Cannot enable peered VPC unless is in the same account, cannot tag a log, cannot change config.
* Not monitored: traffic to DNS, generate by Windows instance, traffic from metadata, DHCP traffic, traffic to reserved IP.
* Application load balancer must be deployed into at least two subnets.
* Not allow perform scan on VPC without alerting AWS.
* NAT gateway - automatically assigned public IP, scale up to 10 GB, not in SG (NAT instance is).
* VPC flow logs is stored in CloudWatch logs - VPC/Subnet/Network Interface levels.  
  
## A Cloud Guru
  
### 什么是 VPC
可以将其想象成一个在云上的虚拟数据中心。  
每次服务开通一个 EC2 实例时都需要设置一个 VPC，如不设置则会被分配到一个默认的 VPC，每个 region 都会有一个默认 VPC，每个 region 的默认 VPC 是你在 AWS 上开通账号时就自动给你配好、提供了。  
VPC 定义：AWS Virtual Private Cloud 让你开通一个 AWS 云的逻辑上独立且相互隔离的部分、区域，在这个部分、区域内你可以定义一个虚拟网络并在上面启动 AWS 资源，你对你的虚拟网络环境有着完全的控制：包括选择你的 IP 地址范围、创建子网、配置路由表与网关。你可以很容易地为 VPC 自定义网络配置，比如你可以为需要连接互联网的服务器创建一个面向公共的子网，然后把后端系统、数据库、应用服务们放在私有子网以规避互联网访问，另外 VPC 还提供了多层次安全的应用 - 包括安全组和网络 ACL 来帮助控制、管理、限制每个子网的 AWS EC2 实例的访问。  
你还可以创建硬件、物理层面的 VPN 连接你的已有数据中心到 VPC 上，从而达到通过 AWS 云扩展你的数据中心的目的。  
  
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/master/Individual%20Product%20Notes/VPC/VPC%20with%20Public%20&%20Private%20Subnet(s).png)  
（注意上图的 SN 即代表子网 subnet）一个子网总是等于一个 AZ，安全组可以扩展子网（比如 Bastion Host / Jumpbox），一个 region 可以有多个 VPC（默认限制 5 个，但可以发邮件向 AWS 额外申请该 region 的更多 VPC 的额度）。  
右上方显示的是 AWS 内置允许你使用的几类内部 IP 地址范围：  
* 10.0.0.0 - 10.255.255.255（10/8 prefix）
* 172.16.0.0 - 172.32.255.255（172.16/12 prefix）
* 192.168.0.0 - 192.168.255.255（192.168/16 prefix）  
以上是关于 CIDR 的（推荐工具网站：http://cidr.xyz/ ），prefix 越多说明范围越小比如 192.168 只有 16（32减16）位（即 2^16 个 IP 地址）供分配而 172.16 则有 20（32减12）位（即 2^32 个 IP 地址）供分配，AWS 允许 prefix 最大值为 28。  
  
### 你可以用 VPC 做什么
VPC 基本上可以说是你的云上的一个虚拟数据中心，你可以通过 VPC 创建子网，每个子网被放进、连入不同的 AZ，子网可以有不同网络地址（比如 10.0.1.0）。  
另外还可以：  
* 选择子网启动实例
* 在每个子网内分配自定义 IP 地址范围
* 配置子网间的路由表（路由表将告知，该 VPC 内哪个子网可以连接哪个子网，以及具体地阻止某个子网连接另外某一个子网）
* 创建互联网网关（Internet Gateway）并附着其到该 VPC 上，每个 VPC 只能有一个互联网网关（互联网网关是高可用的并跨 AZ 的，一个 AZ 出现了 outage 并不会影响另一个 AZ 的互联网网关）
* 对你的 AWS 资源进行更好的安全控制（比如你可以通过使用子网的网络 ACL 来屏蔽来自某个 IP 地址的流量、将实例放入私有子网以防止外部访问）
* 实例的安全组（安全组可以扩展 AZ，安全组可以跨 AZ 因此安全组可以扩展多个子网）
* 子网网络 ACL  
  
### 默认 VPC 对比自定义 VPC
* 默认 VPC 对使用者更易用、友好，可以让你更易更快部署实例、资源
* 默认 VPC 的所有子网都是互联网可访问的（比如在日本部署一个实例，默认的每个 AZ 亦即子网都是互联网可访问的），默认 VPC 没有私有子网，因此你需要自己设置私有子网
* 默认 VPC 里每个 EC2 实例都有一个公共的 IP 地址以及一个私有的 IP 地址，在自定义 VPC 且私有子网里实例则只有私有 IP 地址  
  
### VPC Peering
若不同 VPC 内的资源需要连接、沟通时，可以进行 VPC Peering：  
* 允许你通过一个 direct network route 及使用私有 IP 地址来连接一个 VPC 到另一个 VPC
* 由此，不同的 VPC 的子网内的实例们合作、沟通表现得就如同它们在同一个私有网络内一样
* 你还可以 Peering 另一个 AWS 账号的 VPC
* Peering 是在一种星型配置：即 1 个中心 VPC peer 其余 4 个，这意味着不存在 transitive（传递）peer，即在没有一对一明确配置的情况下其余的 VPC 不能推导地因为都 peer 中心 VPC 从而互相 peer  
  
### 其他
安全组（Security Groups）是 Stateful 的，这意味着总会同时允许 inbound outbound 流量（要不就同时不允许）。  
网络（Network）ACL 是 Stateless 的，即允许 inbound 不代表允许 outbound，反之也一样。  
  
### Lab
1. VPC 控制台 -> 创建 VPC（设置 IPv4 CIDR 块 - 比如 10.0.0.0/16）（还可以设置 IPv6 CIDR 块）
2. 一个默认路由表、一个默认安全组和一个默认网络 ACL 会被自动创建，子网和互联网网关需自己手动创建
3. 创建该 VPC 的子网，设置子网的 IPv4 CIDR 块（需属于该 VPC 剩余可用 IPv4 CIDR 块范围 - 比如 10.0.1.0/24，此例中你将会实际获得 251 个可用 IP 地址而不是 256 个，这是因为每个子网的 CIDR 块的最前 4 个以及最后 1 个 IP 地址默认已被占用，具体请看：https://docs.aws.amazon.com/zh_cn/vpc/latest/userguide/VPC_Subnets.html#VPC_Sizing ）（还可以设置 IPv6 CIDR 块），选择其 AZ（PS：不同 AWS 账号的 AZ 子选项不一定物理地址一样，因为 AWS 会打乱物理数据中心与 AZ 子名的映射顺序以保证均匀分配，因此某人的 us-east-1a 可能物理上等于另一个人的 us-east-1f）
4. 创建互联网网关，并附着其到已有的且未配置有互联网网关的 VPC 上
5. 此例 VPC 的默认路由表（又称主路由表）的默认路由目的地为 10.0.0.0/16、目标为 local，即本例 VPC 下的所有子网均可互相访问，如果新建子网且没有显式地为其关联一个独立的路由表，则该子网会默认关联到主路由表中。因为想让其中一个子网与互联网连接但又不想把主路由表设为互联网可访问（其他关联的或新添加的子网都会互联网可访问），因此需要为该子网新建一个路由表 - 创建路由表时选择归属的 VPC、通过设置目的地为 0.0.0.0/0 以及目标为互联网网关从而设置路由表为互联网可连接（除了 IPv4 也要记得设置 IPv6）、关联想要关联的子网到该路由表，到此该子网就可以连接互联网了。
6. 每个子网各自创建一个实例，测试可得互联网可访问的子网内的实例可通过浏览器访问，另一个子网内的实例则不可访问（注：可以设置新建的 VPC 自动分配 IP，可以让你更方便地通过浏览器访问子网及其实例，主默认 VPC 是默认自动分配 IP 的，但是自定义创建的 VPC 不是默认设为自动分配 IP 的）。创建实例时要新建或选择已有安全组，选择已有安全组时不能选择非本 VPC 的安全组，因为安全组不能跨多个 VPC。
7. 创建或更新安全组时，可以为其添加 Rule，包括配置应用层协议（如 HTTP、SSH）、传输层协议（如 TCP）、端口范围、请求来源与发送目的地（范围限制）（CIDR 形式表达）、Rule 描述。
8. 创建一个新的安全组，添加 MySQL、SSH、HTTPS 等应用层协议以及 TCP 协议，允许请求来源设置为那个公开的子网的 CIDR，则因此公开的子网内的应用就可以访问该安全组内的应用，且尽管新安全组的子网没有连接互联网网关，但此例中仍可以通过公开子网的实例 SSH 进新安全组内的实例。最后可以把已有的实例迁移、换到这个新安全组里。  
PS：以上未设置网络 ACL，因此两个子网共用一个默认的网络 ACL。  
  
### NAT Instance
NAT Instance 准备被 NAT Gateway 替代（https://docs.aws.amazon.com/zh_cn/vpc/latest/userguide/vpc-nat-comparison.html ）。  
通过使用你 VPC 中公有子网内的网络地址转换 (NAT) 实例，可让私有子网中的实例发起到 Internet 或其他 AWS 服务的出站 IPv4 流量（比如下载安装软件），但阻止这些实例接收由 Internet 上的用户发起的入站流量。另：NAT 不支持 IPv6 流量。  
可通过社区 AMI 启动、开通一个 NAT 实例，记得启动时为其配置一个公开的子网，及支持 HTTP/HTTPS 的安全组，然后为其 disable source/destination check（因为 NAT 只是代理），然后私有子网的路由表 outbound 添加该 NAT 实例为目标且 IP 范围为互联网 IP（CIDR 表示即可）。  
NAT Gateway 相比 NAT 实例更好处理单点故障问题更高可用等等。  
  
### Network ACL
一个网络 ACL 只能属于一个 VPC，不能跨 VPC。  
VPC 的主默认网络 ACL 默认允许所有的 inbound 和 outbound 流量，自定义创建的网络 ACL，默认是阻止所有的 inbound 和 outbound 流量直到你添加自定义 Rules。  
VPC 的每个子网都必须关联一个网络 ACL，如果你不显式地关联子网到某个网络 ACL，则该子网会自动关联到默认的网络 ACL。  
你可以关联多个子网到同一个网络 ACL，但一个子网只能关联一个网络 ACL，一旦关联子网到另一个网络 ACL 则该子网的之前的关联就会取消。  
网络 ACL 包括一组 Rules，且从较小数字按序评估。  
网络 ACL 的 Rule 数字大小代表优先度，数字越小优先度越高。  
Rule 数字：AWS 建议数字从 100 开始，且 100 是给 IPv4 而 101 是给 IPv6，其他普通情况下建议新增的每个 Rule 最好按 100 递增。  
网络 ACL 添加 Rule 时与安全组添加 Rule 部分类似，包括配置应用层协议（如 HTTP、SSH）、传输层协议（如 TCP）、端口范围、请求来源（inbound）/发送目的地（outbound）（CIDR 形式表达）。不同的是 ACL Rule 最后有一项 Allow/Deny 选择。    
网络 ACL 的 inbound 和 outbound 的 Rule 是分开设置的，每一方的 Rule 都可以对流量 allow 或者是 deny。  
网络 ACL 是 stateless 的（与安全组的 stateful 不同），比如对 allowed 的 inbound 流量的响应会受到相关 outbound rule 的影响的（反之亦然）。  
安全组无法屏蔽某个 IP 地址，但你可以通过网络 ACL 做到这点、甚至屏蔽一段 IP 范围。  
在架构上，网络 ACL 处在安全组之前面对流量，所以网络 ACL 如果进行屏蔽等操作则安全组即使允许了该类型、协议、来源的流量也无法接收到，因为流量先被网络 ACL 拦截了。  
PS：https://docs.aws.amazon.com/zh_cn/vpc/latest/userguide/vpc-network-acls.html#nacl-ephemeral-ports  
  
