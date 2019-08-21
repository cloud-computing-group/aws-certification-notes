https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html  
IAM（永久免费）使 AWS 根用户能够安全地管理对 AWS 服务和资源的访问。AWS 根用户可以使用 IAM 创建和管理 AWS IAM 用户和组，并使用各种权限来允许或拒绝他们对 AWS 资源的访问，AWS 根用户通过在 AWS 管理控制台上设置这些访问权限。  
IAM 甚至可以精细权限，比如可以针对不同资源向不同人员授予不同权限，比如允许某些用户完全访问 EC2、S3、DynamoDB、Redshift 和其他 AWS 服务，对于另一些用户，可以允许仅针对某些 S3 存储桶的只读访问权限，或是仅管理某些 EC2 实例的权限，或是访问根用户的账单信息但无法访问任何其他内容的权限。  
也可以使用 IAM 设置在 EC2 上运行的应用程序哪些 AWS 服务、资源（比如 S3 存储桶，DynamoDB 表）有哪些访问权限。  



https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html  
AWS STS服务：  
这是一个临时性的密钥，是有时间、IP限制的，通常这是绑定了IAM的某个权限角色的用户的。  



https://docs.aws.amazon.com/IAM/latest/UserGuide/console_sign-in-mfa.html  
使用 MFA 设备访问 IAM 登录页面：  
AWS 根用户可以配置以强制要求 IAM 用户使用其 MFA（多重要素验证）设备登录 AWS 管理控制台。在用户键入用户名和密码后，AWS 将检查用户的账户以查看该用户是否需要 MFA。如果需要，则将显示另一个具有 MFA code 框的登录页面，以便输入 MFA 令牌设备提供的数字代码或以 SMS 文本消息形式发送到用户的移动设备的数字代码。  



## A Cloud Guru - Developer Associate
IAM 可以让用户通过AWS console配置 IAM 的 Resources: Users Account、User Groups、Roles、Identity Provider、Customer Managed Policies 以及一些更进一步的安全设置如 Multi-Factor Authentication（MFA） etc。  
IAM 是全球的，所有配置不分 Region，每个 Region 都一样。但是有一些 Region 的 AWS 服务不一样（比如美国可能上了新的服务但其他地方没有），这样 IAM 配置时也可能根据 Region 有不同的配置、限制，但是与 IAM 本身无关。  
进入 IAM 的Dashboard后，可以看到属于用户个人的 sign-in link（https://{your_customer_account_number}.signin.aws.amazon.com/console），这个link允许用户自己自定义一个更友好的url（只要在全球范围内不重复）。  
  
创建 IAM 用户（User）是因为我们不想所有人、员工都以根用户（root user）的身份访问该 AWS Account（i.e. 公司平台、账号），这是企业、团队的安全以及授权机制的原则。新建用户默认情况下没有任何 permissions。  
创建 IAM Group 是因为我们不想重复地给多个 IAM User 配置同样的授权，因此方便起见可以统一给一个 IAM Group 授权，然后把那些 IAM User 都加到这个 Group 里（日后也可以将 User 添加至/移除出某个 Group）。（除此之外，方便的方法还有Copy permissions from existing user、Attach existing policies directly，AWS 提供了一些default policies，Group 也可以 attach policies，policy 通过 JSON 定义）  
  
设置 Multi-Factor Authentication（MFA）通常选 Virtual MFA Applications（另一个选择是Hardware MFA），市面上可选的App有 Google Authenticator、Authy 2-Factor Authentication、Duo 等等，下载好App后 AWS 会弹出一个二维码框，用刚刚下载的App扫描二维码，App会开始返回来自 AWS 的6位安全码，在 AWS 弹出的二维码框输入两次6位安全码（第二次要等30秒后），确认并激活即可。  
  
### 创建 IAM 用户（User）：  
1. 手动新建一个 IAM 用户：首先选择Access Type，即 Programmatic access 或 AWS Management Console access，可双选。Programmatic access 用于 AWS API、CLI、SDK环境，选定会生成一个初始 access key ID 和 secret access key （创建 User 后显示，请在当时复制保存好或点击旁边按钮“Download .csv”，因为安全机制此后再无法访问此对token），若有 AWS Management Console access 则用户还可以在以后登录console创建新的token对。选定 AWS Management Console access 后，AWS 根用户需填写创建用户名及初始密码（或 IAM 随机生成），并通过复制后发送 IAM 自动生成的邮件邀请模版 - 附上Sign-in URL（类似根用户登录界面，但多一行显示是某 IAM 用户的专属登录界面）和User name，而初始password（如果是随机生成的password可以在生成 IAM 新用户过程的最后一页可以通过点击password tab的show按钮看到，记得复制否则关闭后好像不能再找到show按钮）要以除了上面那封邮件的另外的渠道给予被允许使用该 IAM 新用户的人/团体）。  
2. 关联已有第三方账号来新建一个 IAM 用户：第三方账号通常分为两类，一类是公司网络用户、微软Active Directory（最好兼容SAML2.0），一类是Internet 身份提供商（如 Login with Amazon、Facebook、Google 或任何与 OpenID Connect (OIDC) 兼容的身份提供商）（但 AWS 根用户貌似不可）。  
IAM 用户的使用者不一定是真实的个人或团体，也可以是机器、程序，因此在新建 IAM 用户时其中有一步是选择该用户是纯粹通过程序途径（比如API）访问、操作 AWS 服务及资源还是也可以登录 AWS 管理控制台页面以访问、操作 AWS 服务及资源。  
  
### Manage Password Policy：  
可以对旗下所有 IAM User 推行、强制他们的密码强度（比如至少一个数字、一个大写字母、一个小写字母、密码更新周期 password rotation policies、密码长度等等）。  
  
### 创建 IAM Role：  
Role用于给 entities（如：另一个AWS Account的 IAM User、EC2 实例中的程序、VM 如 EC2 实例、其他对 AWS 资源进行访问或操作的 AWS 服务如 Lambda、通过比如 SAML 认证授权的来自 Corporate Directory 的 User、来自 OpenID Provider / Cognito 的 User，等等） 授权。  
  
### IAM Role 与自定义 Policies - Lab
可以通过向导或 JSON 实现自定义 IAM Policies。  
Policy 基本定义包括：  
* Service（目标服务是哪一类 AWS 服务的，比如 S3）
* Action（动作权限如读、写、删除）
* Resources（这是一个选项，选择是工作于目标服务的指定的资源还是所有的资源 - 比如 S3 的某个/所有 bucket 或某个/所有 object）
* Name（Policy 名称）  
  
然后就可以为你的任意服务（比如 EC2）的任意 IAM Role 设置以使用、添加该 Policy 了。  
注意：更新 Policy 的话不会立即工作（比如添加写权限），会稍微有一些时间延迟。  
Role 可以附加给任意实例（即使实例已经运行）。  
  
### MFA & Reporting with IAM
如上面笔记，启用 MFA，会得到一个二维码（该二维码可用于日后，如果丢失了手机或 MFA 设备的话，所以建议截图保留），下载 MFA 软件扫描该二维码，填入两次认证码即完成启用。  
对于创建的单独的 IAM User 的话，也可以启用，方法如下：  
* 控制台找到该 User 的 Security credentials 设置 -> 在 Assigned MFA device 下选择 yes -> 然后弹出向导框 -> 接下来选择 MFA 类型、扫描二维码并填认证码等步骤与普通 AWS 账号一样。
* CLI - 基本程序与控制台一样，只是通过命令行来开启 MFA 选项以及输入 2 个认证码而已，命令行例子如下（第一个命令下载二维码，你仍需用 MFA 软件扫描该二维码以获得认证码）：  
```shell
aws iam create-virtual-mfa-device --virtual-mfa-device-name EC2-User --outfile /home/ec2-user/QRCode.png --bootstrap-method QRCodePNG
aws iam enable-mfa-device --user-name EC2-User --serial-number arn:aws:iam::"USERNUMBERHERE":mfa/EC2-User --authentication-code-1 "CODE1HERE" --authentication-code-2 "CODE2HERE"
```
  
通过使用 STS（Security Token Service），你还可以强制使用 MFA（在 CLI 上）（即 CLI 访问 AWS 资源在每隔一段时间比如 12 小时后必须重新输入 MFA 认证码并通过才能再访问资源，https://aws.amazon.com/cn/premiumsupport/knowledge-center/authenticate-mfa-cli/）。  
  
IAM 控制台 - Credential Report：  
可下载报告，报告比如你有多少 User 启用了 MFA。  
  
### Security Token Service（STS）
允许用户有限制地临时性地访问 AWS 资源，用户来源于以下 3 个地方：  
* Federation（一般是 Active Directory）
    * 使用 SAML
    * 用户基于其 Active Directory 的身份验证信息（Credential）被允许临时访问，不一定必须是 IAM User
    * 单点登录允许用户登录 AWS 控制台而无需 IAM 身份验证信息
* 手机应用 Federation
    * 使用 Facebook、Google、Amazon 或其他 OpenID provider 来登录
* 跨账号访问
    * 允许另一个 AWS 账号下的 IAM Users 访问该 AWS 账号的资源
  
一些术语：  
* Federation - 将某个域（比如 IAM）下的一组用户和另一个域（比如 Active Directory、Facebook 等等）下的一组用户进行合并、联结
* Identity Broker - 一个允许你从点 A 获取 identity 并联结（join、federate）到点 B 的服务
* Identity Store - 像 Active Directory、Facebook、Google 等等这类服务
* Identities - 一个服务（如 Facebook 等等）里的一个用户、身份  
  
一个场景：  
你托管了一个网站在 EC2 实例且在你的 VPC 上。用户通过他们在公司总部的 Active Directory 服务器上的身份登录网站以进行认证、授权分析，你的 VPC 通过安全 IPSEC VPN 连接到该公司总部，一旦成功登录，用户将可以且只可以访问其个人所属的 S3 bucket。请问实现这一场景需求。  
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/master/Individual%20Product%20Notes/IAM/Scenario%20Solution.png)
  
步骤如下：  
1. 用户输入账号名和密码
2. 应用程序、网站（即 reporting application）调用 Identity Broker，broker 获取账户名和密码
3. Identity Broker 使用组织的 LDAP directory（延伸：也可以是其他如 Facebook、Google 等）来确认用户的身份
4. Identity Broker 使用 IAM 身份验证信息调用新的 GetFederationToken 方法，该调用必须包含一个 IAM Policy（指定权限被授予一个临时安全的身份验证信息）和一个持续时间（1 至 36 小时）
5. STS 确认 IAM User 的 Policy 调用了 GetFederationToken 方法并给予了权限以创建新的令牌，然后返回 4 个值给应用：一个 access key、一个 secret access key、一个令牌、一个持续时间（令牌的可用时间）
6. Identity Broker 返回临时安全的身份验证信息到应用程序、网站（reporting application）
7. 数据存储应用使用该临时安全的身份验证信息（包括令牌）向 S3 发起请求
8. S3 使用 IAM 以确认身份验证信息被允许对给定的 S3 bucket 和 key 作请求操作
9. IAM 告知 S3 请求合规、通过可以操作  
  
