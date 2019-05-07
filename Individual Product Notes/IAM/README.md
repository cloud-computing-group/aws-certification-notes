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



### A Cloud Guru - Developer Associate
IAM 可以让用户通过AWS console配置 IAM 的 Resources: Users Account、User Groups、Roles、Identity Provider、Customer Managed Policies 以及一些更进一步的安全设置如 Multi-Factor Authentication（MFA） etc。  
IAM 是全球的，所有配置不分 Region，每个 Region 都一样。但是有一些 Region 的 AWS 服务不一样（比如美国可能上了新的服务但其他地方没有），这样 IAM 配置时也可能根据 Region 有不同的配置、限制，但是与 IAM 本身无关。  
进入 IAM 的Dashboard后，可以看到属于用户个人的 sign-in link（https://{your_customer_account_number}.signin.aws.amazon.com/console），这个link允许用户自己自定义一个更友好的url（只要在全球范围内不重复）。  
  
创建 IAM 用户（User）是因为我们不想所有人、员工都以根用户（root user）的身份访问该 AWS Account（i.e. 公司平台、账号），这是企业、团队的安全以及授权机制的原则。新建用户默认情况下没有任何 permissions。  
创建 IAM Group 是因为我们不想重复地给多个 IAM User 配置同样的授权，因此方便起见可以统一给一个 IAM Group 授权，然后把那些 IAM User 都加到这个 Group 里（日后也可以将 User 添加至/移除出某个 Group）。（除此之外，方便的方法还有Copy permissions from existing user、Attach existing policies directly，AWS 提供了一些default policies，Group 也可以 attach policies，policy 通过 JSON 定义）  
  
设置 Multi-Factor Authentication（MFA）通常选 Virtual MFA Applications（另一个选择是Hardware MFA），市面上可选的App有 Google Authenticator、Authy 2-Factor Authentication、Duo 等等，下载好App后 AWS 会弹出一个二维码框，用刚刚下载的App扫描二维码，App会开始返回来自 AWS 的6位安全码，在 AWS 弹出的二维码框输入两次6位安全码（第二次要等30秒后），确认并激活即可。  
  
创建 IAM 用户（User）：  
1. 手动新建一个 IAM 用户：首先选择Access Type，即 Programmatic access 或 AWS Management Console access，可双选。Programmatic access 用于 AWS API、CLI、SDK环境，选定会生成一个初始 access key ID 和 secret access key （创建 User 后显示，请在当时复制保存好或点击旁边按钮“Download .csv”，因为安全机制此后再无法访问此对token），若有 AWS Management Console access 则用户还可以在以后登录console创建新的token对。选定 AWS Management Console access 后，AWS 根用户需填写创建用户名及初始密码（或 IAM 随机生成），并通过复制后发送 IAM 自动生成的邮件邀请模版 - 附上Sign-in URL（类似根用户登录界面，但多一行显示是某 IAM 用户的专属登录界面）和User name，而初始password（如果是随机生成的password可以在生成 IAM 新用户过程的最后一页可以通过点击password tab的show按钮看到，记得复制否则关闭后好像不能再找到show按钮）要以除了上面那封邮件的另外的渠道给予被允许使用该 IAM 新用户的人/团体）。  
2. 关联已有第三方账号来新建一个 IAM 用户：第三方账号通常分为两类，一类是公司网络用户、微软Active Directory（最好兼容SAML2.0），一类是Internet 身份提供商（如 Login with Amazon、Facebook、Google 或任何与 OpenID Connect (OIDC) 兼容的身份提供商）（但 AWS 根用户貌似不可）。  
IAM 用户的使用者不一定是真实的个人或团体，也可以是机器、程序，因此在新建 IAM 用户时其中有一步是选择该用户是纯粹通过程序途径（比如API）访问、操作 AWS 服务及资源还是也可以登录 AWS 管理控制台页面以访问、操作 AWS 服务及资源。  
  
Manage Password Policy：  
可以对旗下所有 IAM User 推行、强制他们的密码强度（比如至少一个数字、一个大写字母、一个小写字母、密码更新周期 password rotation policies、密码长度等等）。  
  
创建 IAM Role：  
Role用于给 entities（如：另一个AWS Account的 IAM User、EC2 实例中的程序、VM 如 EC2 实例、其他对 AWS 资源进行访问或操作的 AWS 服务如 Lambda、通过比如 SAML 认证授权的来自 Corporate Directory 的 User、来自 OpenID Provider / Cognito 的 User，等等） 授权。  
