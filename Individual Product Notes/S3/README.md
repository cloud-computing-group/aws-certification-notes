## A Cloud Guru
  
### 什么是 S3
S3 (Simple Storage Service) 提供开发者及其 IT 团队安全、耐用、可扩展的对象存储服务（可以存文件、图片、网页文件，但不包括操作系统或数据库）。S3 易用并提供了一个简单的 web 服务接口使得开发者、程序在互联网的任何地方都能存取任何体量的数据。  
S3 是一个安全存放文件的地方，它是 Object-based storage（而非 blob storage，blob storage 主要支持非结构化数据），存放的数据会分散在不同的硬件、设备、设施上（高可靠性、可灾难恢复，即使某些硬件甚至某个 Region、Availability Zone 出现问题 S3 仍然正常运作）。  
  
### S3 基础
* S3 是 Object-based 的，意味着你可以上传、保存文件
* 保存的单个文件大小限制为：最小为 0 字节，最大至 5 TB
* S3 没有存储上限限制
* 文件存放于 Buckets（AWS 术语，其实与 folder 同义词）中
* S3 是 universal namespace，即 bucket 名字需全球唯一
* https://s3-eu-west-1.amazonaws.com/{globally_unique_bucket_name}
* 当成功上传文件到 S3 时，会返回一个 HTTP 200 状态码（只有通过 CLI 或 API 才返回状态码，通过控制台则不会看到状态码）
  
### S3 的数据一致性模型、特性
* PUTS（新建）一个新的对象（文件）时，执行 Read after Write Consistency（即写入后即可立即读取）
* Overwrite PUTS（更新）和 DELETES（删除）执行 Eventual Consistency（即变动需要过一段时间才会读取到、传播完成）
  
### S3 是 Key-value 存储
S3 是 Object-based，Object 包括以下：
* Key（对象的名）
* Value（即数据，由字节序列组成）
* Version ID（因 S3 支持版本控制）
* Metadata（比如标签 Tags）
* Subresource（bucket-specific configuration）
    * Bucket Policies，Access Control Lists，（即 bucket 内容访问权限）
    * Cross Origin Resource Sharing - CORS（bucket A 的文件拥有访问 bucket B 的文件的权限）
    * Transfer Acceleration（提升上传大量文件到 S3 上的速度）
  
### S3 基础
* S3 平台通常 99.99% availability（99.99% 的时间里都能正常访问）
* Amazon 保证 99.9% availability
* Amazon 保证 S3 的信息 99.999999999%（助记11*9s）durability（数据不丢失）（同时最好也做 backup，permission 限制权限操作如删除）
* 层级存储（tiered storage - standard, IA, One Zone IA etc）
* Lifecycle 管理（数据在各个阶段往不同存储层级甚至 AWS Glacier 迁移，以优化成本的同时又满足系统需求）
* 版本控制
* 数据加密
* 保护数据访问（Bucket Policies，Access Control Lists）

### S3 存储层级/类别
* S3（标准）： 99.99% availability 以及 99.999999999% durability，因为其重复存储在不同的硬件、设备上，可以承受两个硬件、设备或是数据中心（甚至不同 region）的 outage。
* S3 - IA：IA 即数据是 Infrequently Access 的（比如一年或一季才访问一次），但是在需要时可快速访问，费用比 S3 标准版低，但是 retrieval（恢复）要另外收费。
* S3 - One Zone IA：类似 IA 但是数据只存储在一个 Availability Zone 里，保持 99.999999999% durability 但是 99.5% availability。费用比 IA 还要低 20%。但是如果那个 Availability Zone 发生 outage 了，则应用所需的这部分数据访问就宕掉了。
* Reduced Redunancy Storage：设计为该年 99.99% availability 以及 99.99% durability。应用场景为存储那些不重要的、丢失后但可容易重新生成的数据（比如缩略图），注意此层级、类别在某些 region 不提供，且 AWS 以后可能不再支持此层级。
* Glacier：非常便宜，只用于档案性质的存储。不能实时访问数据，通常需要 3-5 小时去恢复、提取数据。99.99% availability（数据恢复后）以及 99.999999999% durability。
  
### S3 智能层级（Intelligent Tiering）
* 未知的或难以预估的数据访问情况/模式
* 2 个层级，频繁与非频繁访问（后者比前者便宜）
* 基于每个 object 现有访问频率记录，自动迁移相关数据到最经济的层级（比如 object 在 1 个月内没有任何访问则 AWS 自动将其迁移到非频繁访问层级，一旦访问则重新迁移回频繁/标准层级）
* 99.999999999% durability
* 该年 99.9% availability
* 优化成本
* 访问数据不另外收费，但是每个月有一笔固定小费用用于监控/自动化数据 - 每 1000 object 收费 $0.0025
  
### S3 收费
* 存储量（按单位 GB）
* 访问请求（Get, Put, Copy etc）
* 存储管理费用
    * Inventory, Analytics 和 Object Tags
* 数据管理费用
    * 数据向 S3 外传输（往 S3 里传输数据是免费的，比如上传文件）
* 传输加速
    * 使用 CouldFront 优化数据传输
  
### 更多参考：
FAQ：https://aws.amazon.com/s3/faqs/
  
### S3 Security - Securing Your Buckets
* 默认情况下，新建的 bucket 都是 PRIVATE 的。
* 可以通过以下为 bucket 设置访问权限：
    * Bucket Policies（可通过 JSON 设置）：可作用于单个 bucket 上（被授权人或组能且只能访问/操作该 bucket 中的数据）
    * Access Control Lists：可作用于单个 object 上（被授权人或组能且只能访问/操作该 object 数据）
* S3 bucket 可以通过配置来创建访问日志，该日志会自动记录所有对该 bucket 的访问记录，而该记录可以被写进到另一个 bucket 中。（创建 bucket 时的第二步的 Server access logging 就可以选择启用日志以记录访问、请求记录。补充：第二步里另外有选项甚至可以启用基于 AWS CloudTrail 的 Object-level logging 即记录 Object-level 的 API 交互记录）
  
### S3 ACLs & Policies
Steps:  
1. 创建 bucket，（补充可以在此步骤启用加密，默认可选 AES-256 或 AWS-KMS）
2. 访问限制公共 ACLs 或 Policies 操作该 bucket（可在上一步或之后设置，初始默认为限制）（除了通过创建步骤，你也可以在之后在 Permission 选项卡里通过编写 JSON 来设置这些）
3. 在 bucket 中创建文档并上传文件（Object-level），在 set permission 一栏，可以赋予权限给某 User 或甚至某 Account 甚至公共可访问（其实即是设置 ACLs，并且 ACLs 是 Object-level 的）。（set permission 之后可设置 S3 层级/类别、元数据以及加密）
  
在拥有相关权限后，你可以通过控制台的 Open 按钮打开/访问 S3 私密文件（会使用并验证你的 AWS 账号 credentials），但是如果通过浏览器地址栏直接输入 S3 文件链接则不行，因为浏览器打开 S3 文件链接时是以匿名形式打开的，因此即使已经在该浏览器已登录了拥有权限的 AWS 账号，你仍然无法直接通过文件链接下载或打开文件，除非将该文件设置成公共可访问（但所在 bucket 也必须是公共可访问的，但是公共的 bucket 却可以把里面的某个或某些文件设置成非公开的、私密的）。
  
### S3 Encryption（加密）
* 在传输过程中加密
    * SSL / TLS

* 其他
    * 服务端加密
        * S3 管理密钥 - SSE-S3（每个 object 都被自己独有的密钥进行多重要素加密，这些密钥同时也被一个主密钥加密，该主密钥会定时更新，这些全部自动由 AWS 运作，且全部为 AES-256 加密标准）（以上加密只需通过在 S3 里设置 object 时启用 encryption 选项即可，十分简单方便）（参考：https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#enveloping）
        * AWS Key Management Service，管理密钥，SSE-KMS（此服务 AWS 为你管理密钥，你会获得一个 envelope 密钥的独立的权限，该密钥用于加密那些加密你的数据的密钥，在高级别层面上防止非认证访问，并且会有审计记录每次加密密钥的使用、S3 bucket 加密解密操作、原因等等的历史。在实际应用中除了可以使用系统提供的默认的全球独你拥有的唯一密钥外，你也可以用自己的自定义的密钥）
        * 用自定义/自提供的密钥进行服务端加密，SSE-C（AWS 负责、管理系统中加密解密等所有安全过程处理、操作，但是由开发者自己进行密钥的管理 - 包括安全放置收藏、定时更新、生命周期等等）
    
    * 客户端加密（开发者在上传文件至 AWS 平台比如 S3 之前，先对文件、数据进行加密。因此开发者可自行选择加密方法方式、选择自己的应用来进行加密过程）
  
### 强制 S3 上的 bucket 进行加密（服务端加密）
* 每次文件上传至 S3 时，会初始化一个 PUT 请求
* 该 PUT 请求如下：
```
PUT /myFile HTTP/1.1
Host: myBucket.s3.amazonaws.com
Date: Web,25 Apr 2018 09:50:00 GMT
Authorization: authorization string
Content-Type: text/plain
Content-Length: 27364
x-amz-meta-author: myName
Expect: 100-continue
x-amz-server-side-encription-parameter: AES256
[27364 bytes of object data]
```
* 如果要在上传时进行加密（服务端加密），请求的 header 里应包括  x-amz-server-side-encription-parameter
* 现在有两种参数选择：
    * x-amz-server-side-encription-parameter: AES256 （SSE-S3）
    * x-amz-server-side-encription-parameter: ams:kms （SSE-KMS）
* 当在 PUT 请求 header 里调用以上之一的参数时，即告知 S3 在文件上传过程中使用制定方法加密文件、数据。
* 可以通过 S3 bucket 的 permission 里设置 bucket policy 强制服务端加密，设置为任何不包括 x-amz-server-side-encription-parameter 的 S3 PUT 请求都会被拒绝。
  
### Set Up Encryption On an S3 Bucket
awspolicygen.s3.amazonaws.com/policygen.html（这个地址可以通过各种下拉菜单选择、表格填写，自动方便地生成各种 policy 的 JSON 设置代码）  
上传代码时，创建过程里的 Set properties 的 Encryption 选项是服务端加密（即与 x-amz-server-side-encription-parameter 相关）。
  
### CORS Configuration Lab
