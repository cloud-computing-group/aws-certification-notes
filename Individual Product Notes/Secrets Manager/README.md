## A Cloud Guru
  
### 什么是 Secrets Manager
帮你保存你的应用、服务、资源访问时所需的密钥的服务。  
* 使用你的 KMS 的加密钥匙来加密密钥（at rest，参考：https://brightlineit.com/encryption-at-rest-important-business/）
* 密钥可以是数据库凭证、密码、第三方 API Key 或仅仅文本数据
* 你可以通过 Secrets Manager 控制台、CLI、API、SDK 来存储或控制访问这些密钥
* 这些凭证、密钥不必写死在源代码或程序里，而是代码在运行时再通过调用 API 获取（更安全）
* 密钥根据你的时间表设定，自动地轮换、轮替（rotate）  
  
案例场景：  
1. 管理员为一个应用的新数据库设置、建立密钥
2. 管理员把该密钥存入 Secrets Manager 中，Secrets Manager 存储前会加密密钥
3. 当应用需要访问数据库需要密钥时，应用请求 Secrets Manager 提供该密钥
4. Secrets Manager 收到请求后解密密钥并通过 HTTPS/TLS 将其返回给应用
5. 应用使用该密钥访问、操作数据库数据  
  
### Lab
密钥实例创建步骤：  
1. 在 Secrets Manager 存入新密钥时有 3 种选项：  
    * RDS 的密钥、凭证
    * 其他数据库的密钥、凭证
    * 其他类型密钥（比如 API Key、文本数据）  
2. 选择用于加密密钥的钥匙（默认由 KMS 提供）
3. 选择使用该密钥的对象 - RDS 实例（步骤 1 选 RDS 时）
4. 填入密钥实例的名与描述、标签
5. 设置密钥轮换时间表（比如此案例数据库初始密码设置好后，达到轮换时间后 Secrets Manager 会自动更新 RDS 的密钥并更新到此密钥实例中）
6. Review，点击完成  
  