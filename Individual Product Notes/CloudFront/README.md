## A Cloud Guru
  
### 什么是 CDN？
Content Delivery Network 的缩写，是一个可以基于用户物理地址选择地理上最靠近或网速效率上最高的 webpage、content delivery 服务器或数据中心来快速传递网络资源（如图片、CSS、HTML、音视频、文件等非频繁更新文件、数据）的分布式网络或系统。简单说就是优化客户的网站网速体验（访问、读取、下载等等）。  
除了客户的网站体验之外，CDN 技术还可用于其他地方如 S3 的 Transfer accelerate，Transfer accelerate 与上面的 webpage 案例不同的是，用户上传或更新数据时，这些请求会先发送至那个地理、效率上最高的服务器、数据中心（一般称之为 Edge server）并同时缓存，然后再发送至可能千里之外的中心服务器、数据中心。这样就可以有效优化效率或负载压力。（S3 的 Transfer accelerate 就很好地使用了 CloudFront 技术安全地分发数据缓存至全球 Edge 服务器从而实现以上优化，反向同步时则使用 optimized network 同步数据回中心服务器、数据中心）  
  
所有的 Edge 服务器、数据中心都有一个缓存的 TTL（Time To Live），意思是一个缓存持续时间、如果每过一次这个时间间隔，无论是否有客户访问或更新都会自动和中心服务器、数据中心做一次数据同步、更新。  
也可以操作、在未到 TTL 时进行手动强制更新 Edge 服务器们的缓存，但是这会造成额外的费用。  
  
### Key Terminology
* Edge Location - 这是 content 被缓存或读写更新的地方（服务器、硬件），与 AWS 的 Region/AZ 不同，要小一些。
* Origin - CDN 分发内容、文件的源，可以是 S3 bucket、EC2 实例、ELB 或 Route53。
* Distribution - CDN 的一个术语，表示一群 Edge Locations 组成的集。
    * Web Distribution - 该 Distribution 通常用于网页、图片、文件等（适用于协议如 HTTP、HTTPS）。
    * RTMP Distribution - 该 Distribution 用于视频流或 Flash multi-media content（适用于协议如 Adobe Real Time Message Protocol）。
  
### 什么是 CloudFront
通过布置在全球的 Edge Locations（五大洲，大概 29 个国家，服务点总数上百以上），AWS CloudFront 提供服务于动态网站、静态网站、流数据、交互内容的 CDN 功能。用户的请求会被自动路由至地理位置上最靠近他们的Edge Location 服务器、硬件上。（比如对 S3 bucket 文件的访问）  
除了可以优化、服务 AWS 自家的服务（如 S3、EC2 等），CloudFront 还可以无缝用于你自己的服务器、硬件、数据中心（non-AWS origin server），用于缓存你自己的硬件上的 origin 或是版本控制的文件、数据、contents 等。  
  
### Exam Tips
* Edge Location 不是只能读，也支持写操作（比如 PUT 新数据）。
* CloudFront Edge Location 被 S3 Transfer acceleration 使用来减少用户上传至 S3 的延迟。
* Objects 缓存有一个 TTL（Time To Life）。
* 可以手动清楚缓存 objects，但是要被收额外费用。
  
### CloudFront Lab
Steps：  
1. 在 CloudFront 控制台，点击创建 Distribution（并选择 Distribution 类型：Web 或 RTMP）。
2. 新建 Distribution 的 Origin 设置（如域名即被分发源文件、数据的 URL、IP 地址如 S3 bucket、EC2 实例、自己的服务器文件等等；又如文件路径、安全与访问权限、自定义 HTML header、强制 HTTPS、设置 TTL、IPv6 等等，其中最重要的是 Origin Access Identify，这会强制所有用户不能直接访问、交互 origin 服务器的如 S3 bucket，而是先访问 Edge 服务器）。
3. 等待一段时间等 provision 完成（前面的设置也可以在 provision 之后更新，包括增加 origin 等等）（在同一界面你可以进行手动的 Edge 缓存清楚操作，需额外费用）。  
PS：可以通过该 CloudFront Distribution 的 Behaviors 设置当需要引用、获取某些文件时（比如 HTML 里引用、指定路径的文件如 images/*、css/*）即搜寻、映射到另一个指定的文件来源（比如 S3 某 bucket 的某文件、图片等等）（在映射来源之前需先为该 CloudFront Distribution 增添该 S3 文件路径为一个新的 Origin）（注：Behaviors 设置里有一个默认 Behaviors 将不匹配其他 Behaviors 的所有文件获取都归类于该 Behaviors 下）  
