## CSAA Test Notes:  
* Limite 50 domain names, can contact AWS to expand.
* Simple routing: one record for multiple IP, rotating by random order, no health check.
* Multivalue routing: multiple values, with health check.
* Health check on endpoint, state of CloudWatch alarms, status of other health checks.  
  
  
  
## A Cloud Guru
为什么叫 Route53？因为 DNS 在端口 53 操作执行。  
  
### DNS
DNS 是用来转换域名到 IP 地址（IPv4、IPv6）的服务，就如同电话簿一样将人名与其电话号码映射起来，而 IP 地址和电话号码才能被机器识别，域名与人名则是方便人类使用的键。  
IPv4 是 32 位的。  
IPv6 是 128 位的，为解决 IPv4 地址枯竭的问题而诞生，其地址数量远超 IPv4。  
了解：顶级域名、二级域名等等。顶级域名由 IANA 控制，IANA 使用一个数据库保存这些顶级域名：https://www.iana.org/domains/root/db  
为了保证每个人或公司、机构使用的域名唯一不重复，域名商（如 GoDaddy.com、AWS Route53 等等）应运而生，因此人们可以通过互联网在域名商的网站注册、购买域名（其唯一性通过 ICANN 的一个服务 - InterNIC 保证），每个域名最终都会被注册进一个中央数据库 - WhoIS 数据库。  
  
### Start of Authority Record（SOA）
所有 DNS 都有 SOA 记录，SOA 记录是保存在 DNS zone 的关于该 zone 的信息，包括以下信息：  
* 提供数据给该 zone 的服务器的名字
* zone 的管理员
* 数据文件的现有版本
* 资源记录上的 time-to-live 文件的默认秒数（越少越好）  
一个 DNS zone 是 DNS 服务器负责的域名的一部分（即保存 A Record、CName 等信息），每个 zone 包含一个 SOA 记录。  
更多关于 zone：https://blog.csdn.net/huangzx3/article/details/79347556  
  
### NS（Name Server）Record
被顶级域名的服务器使用于将流量导向内容 DNS 服务器（存有权威性 DNS 记录）。  
  
### A Record
“A” Record 是 DNS Record 的基本类型，“A” 意即 ”Address“，“A” Record 被计算机用于转换域名到 IP 地址。  
  
### TTL
DNS 记录被缓存在 Resolving Server 或用户本地 PC 的持续时间。时间低则会更频繁地通过互联网进行域名解析获取 IP。按秒为单位。  
  
### CName
标准名的意思，用于将一个域名转换、映射到另一个域名上，即两个域名指向同一个 IP 地址。  
  
### Alias Record
Alias Record 用于映射你的 hosted zone 里的资源记录集到 ELB、CloudFront 分布或 S3 buckets 这些被配置成网站的资源。  
Alias Record 与 CName 工作原理类似，即映射一个 DNS 域名（www.example.com）到另一个目标 DNS 域名（elb1234.us-east-1.elb.amazonaws.com），但两者的关键不同点在于 CName 不能指向裸域名（即 zone apex record，比如 http://acloud.guru），裸域名只能使用 A Record 或 Alias Record。  
即目标域名的 IP 变动时（但目标域名需对应上新 IP），原有 Alias Record 无需更改也不会受影响且会自动、快速、低延迟地响应最终 IP 的变动。  
  
### Exam Tips
* ELB 没有预定义 IPv4 地址，所以需要使用其 DNS 域名（系统自动生成的）动态地获取其 IP 地址。所以如果设计网站流量门户为 ELB 的话，需要使用 Alias Record 映射网站域名以及 ELB 地址（因为 ELB 没有固定 IP 地址且其域名为裸域名）
* 尽量现在使用 Alias Record 而不是 CName
* 常见 DNS 类型还有 MX Record、PTR Record