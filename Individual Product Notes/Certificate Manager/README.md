## A Cloud Guru
  
### 什么是 Certificate Manager
方便你开通、管理以及部署 SSL、TLS 证书，以及将证书日后方便使用于各应用、服务的服务。  
  
### 特性
* 统一管理你的 AWS 平台上所需使用的证书
* 通过 CloudTrail 日志审计每个证书的使用情况
* 私有证书使用权限（比如管理私有证书生命周期、内部使用的证书等等）
* 与其他 AWS 服务的集成（通过 CloudFront API Gateway 部署在你的 ELB）
* 从其他 CAs 导入你的第三方证书  
  
### Lab
通过 Certificate Manager 在 AWS 申请证书步骤：  
1. 添加域名
2. 添加验证方式（可以域名、Email，此案例选择域名）
3. Review
4. 验证（为了验证通过：到 Route53，选择域名 - 需是步骤 1 的域名，创建 record set - 填入此验证中的 name，类别选择验证中的类别比如 CNAME，填入验证中的 value，Route53 创建完成后过大概最多 72 小时验证就会通过，当然除了 Route53 你也可以使用其他域名供应商）  
  
使用步骤：  
1. 创建 ELB 实例，协议选择 HTTPS
2. 证书设置页面，证书类型此案例选择来自 ACM 的，证书名填选上面申请到的证书的 ARN
3. 设置好其他 ELB 选项启动实例即可 HTTPS 访问该 ELB 地址了