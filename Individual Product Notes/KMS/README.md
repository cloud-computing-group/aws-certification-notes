## A Cloud Guru
  
### KMS 101
KMS 服务提供了简单易用的平台来创建、管理加密密钥来加密你在其他服务里的数据、信息，其支持加密数据的对象服务包括：EBS、S3、RDS、Redshift、Elastic Transcoder、WorkMail 等等。  
步骤：  
1. IAM 先创建组、用户以及附着 KMS 访问策略
2. 用户会有管理密钥访问权限（即密钥对的权限范围、可以访问哪些资源）管理权，但不能操作密钥的加密解密（具体该密钥加密解密操作交由相关部门自己的开发者执行）
3. IAM Encryption keys 选项卡选择 region 并新建密钥（material 选项时选择 KMS 负责加密）
4. 选择密钥的管理组（刚刚创建的组）及具体用户权限，从而该组用户可以通过 KMS API 管理其密钥  
可见 KMS 没有控制台（但存在，且通过在 IAM、S3 或其他服务的向导里被使用）  
  
IAM 虽是全球的但其 Encryption keys 选项卡是基于 region 的，所以使用这里的密钥时注意使用它的服务是否在同一 region。  
  
* 自定义主密钥（CMK - KMS Customer Master Key）
    * Alias
    * 创建日期
    * 描述
    * 密钥状态
    * 密钥材料（key material，可由自己或 AWS 提供）  
注：密钥无法导出（如果想要导出应该使用 CloudHSM，CloudHSM 与 KMS 不同之处在于 KMS 运行在多租户硬件、服务器上而 CloudHSM 是运行在你自己的专用服务器上）  
  
* 定义密钥的管理权限 - 通过 KMS API 管理（但不能使用）密钥的IAM 用户或 role
* 定义密钥的使用权限 - IAM 用户或 role 可以使用该密钥加密解密数据  
  
### KMS API
Lab 步骤：  
1. 创建一个 EC2 实例（实例应该与 KMS 密钥在同一个 region）
2. SSH 进入 EC2 实例，在里面随意创建一个文本文件（比如命名为 secret.txt，后面的脚本会以 fileb://secret.txt 引用）
3. aws configure -> 填入、使用前面 KMS 给予使用权限的 IAM User 的密钥对以及设置 region
4. 运行以下脚本（Key ID 在 前面的 IAM Encryption keys 选项卡才创建的密钥、region 里找）  
```bash
aws kms encrypt --key-id YOURKEYIDHERE --plaintext fileb://secret.txt --output text --query CiphertextBlob | base64 --decode > encryptedsecret.txt
aws kms decrypt --ciphertext-blob fileb://encryptedsecret.txt --output text --query Plaintext | base64 --decode > decryptedsecret.txt
aws kms re-encrypt --destination-key-id YOURKEYIDHERE --ciphertext-blob fileb://encryptedsecret.txt | base64 > newencryption.txt 
aws kms enable-key-rotation --key-id YOURKEYIDHERE
```
注：这里 key rotation 会每年 rotate 一次密钥。  
  
### Exam Tips
要记得 4 个 API：  
* aws kms encrypt
* aws kms decrypt
* aws kms re-encrypt
* aws kms enable-key-rotation  
  
### Envelope Encryption
用 KMS Customer Master Key（CMK）加密 Envelope Key (Data Key)，加密服务里的数据的过程里会先用 KMS Master Key 通过密码算法解密之前加密后的 Envelope Key 获得的原来的 Envelope Key 原值再来对服务里的数据进行加密。  
* KMS Master Key 负责加密解密 Envelope Key
* Envelope Key 的原值负责加密解密服务里的数据、信息  
  
### Exam Tips
删除一个 KMS 密钥时需要先 disable 并 schedule 后等待 7 至 30 天（schedule 时选择具体时间）后才真正删除。  
KMS 是 free-tier eligible。  
  
### 更多
CloudHSM 提供对称加密与非对称加密，KMS 只提供对称加密。  