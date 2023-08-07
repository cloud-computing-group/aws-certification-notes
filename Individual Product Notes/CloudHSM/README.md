## A Cloud Guru
  
### KMS and CloudHSM
* 两者都是创建、管理、保存密钥以保证你在 AWS 上的数据的安全。  
* HSM（Hardware Security Modules）是用来保护保证你的密钥的机密性，它是一个物理设备（https://zh.wikipedia.org/wiki/%E7%A1%AC%E4%BB%B6%E5%AE%89%E5%85%A8%E6%A8%A1%E5%9D%97 ），提供加密以及数字签名功能、从而可以管理密钥以加密数据，常常用于比如金融支付系统，KMS 和 CloudHSM 都使用了它。  
* 两者都提供了高度的安全保护机制。  
  
KMS 是共享底层硬件设备的 - 在云数据中心里是多租户管理的，适用于多租户硬件管理对其不会带来问题的应用（但比如银行系统就不适用），Free-Tier eligible。  
  
CloudHSM - 专用 HSM（Hardware Security Module）实例、主机，因此硬件设备不与其他租户共享（也就没有 Free-Tier 了）。  
HSM 连接入你的 VPC 内、由你独家控制掌管。  
  
#### CloudHSM
* FIPS 140-2 Level 3 compliance（HSM 的美国政府标准），包括 tamper evident 物理安全机制
* 适用于需要定期地、合同期地要求专用硬件设备来管理加密密钥的应用（支付卡厂商、银行交易系统、金融服务）
* 使用例子包括：数据库加密、Digital Right Management、Public Key Infrastructure、认证与授权、文档签名、交易处理、加密 AWS 云平台数据等等
  
CloudHSM 提供对称加密与非对称加密，KMS 只提供对称加密。  