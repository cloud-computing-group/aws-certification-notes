## A Cloud Guru
  
### Web Identity Federation
Web Identity Federation 可以使你的用户在认证了其他网络身份供应商（IDP 如 Amazon、Facebook、Google 等）后有权访问 AWS 资源。  
遵从认证流程，用户从网络身份供应商处收到认证码，并用其交换到临时的 AWS 安全凭证。  
AWS Cognito 就是提供 Web Identity Federation 的服务。并提供以下特性、功能：  
* 注册、登录你的应用
* 游客访问（使用账号密码）
* 工作机制类似（你的应用与 IDP之间的）身份中间商，而你无需写额外的代码、逻辑
* 同步用户数据到多个设备
* 建议运行在 AWS 上的手机应用使用此服务  
  
### AWS Cognito Use Cases
建议 Web Identity Federation 使用社交网络账号，比如 Facebook 等。  
Cognito 在获取 IDP 认证确认信息后，会返回一个临时凭证，该凭证是映射/对应到某个 IAM Role 的，因此用户在应用中可以通过它得以访问相关被授权的服务、资源。  
因此应用代码内、设备上无需嵌入、保存 AWS 凭证，用户也因此可以在多个不同的设备、平台上获得相同的、无缝的体验。  
  
工作流程：  
1. 应用重定向用户到 IDP 认证页面，用户在 IDP 页面上认证身份（输入账号密码或使用浏览器 cookie 等等）
2. IDP 认证成功后 IDP 会返回给应用一个 authentication token
3. 应用将此 authentication token 发送给 AWS Cognito 换取一个临时的 AWS 凭证
4. 用户在应用中使用该临时的 AWS 凭证即 assume 一个 IAM Role，可以访问该 Role 被授权的服务、资源  
  
### Cognito User Pools
* User Pools 是用户目录，用来管理应用的注册、登录。  
    * 用户可以直接通过 User Pools 登录或通过认证 IDP 登录。  
    * 成功认证后会生成一些 JWTs。  
* Identity Pools 允许你为用户创建唯一的身份并通过 IDP 认证他们，通过该身份，用户可获得一个临时的特权受限的凭证，并使用它以访问其他 AWS 服务  
  
### 推送同步
Cognito 跟踪用户在其登录的不同设备之间的关联，为了提供更好地无缝体验，Cognito 使用推送同步机制以同步不同设备上同一个用户的数据，即当用户数据更新到云数据存储系统时，AWS SNS 被用来发送一个后台推送通知到该用户登录的所有设备上。  
  
### Lab
Cognito 和 Auth0 很相似。  
<Your Cognito Domain>/login?response_type=token&client_id=<Your App Client ID>&redirect_uri=https://example.com  
最后认证成功后重定向到应用的域名 https://example.com/#id_token={jwt}  
应用 URL 有了 token 参数即可解码并因此获取访问 AWS 服务、资源权限  
可以为 User Pools 里的用户设置 IAM 比如 ognito Group（设置附着 IAM Role）  
