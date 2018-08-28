https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html  
IAM（永久免费）使 AWS 根用户能够安全地管理对 AWS 服务和资源的访问。AWS 根用户可以使用 IAM 创建和管理 AWS IAM 用户和组，并使用各种权限来允许或拒绝他们对 AWS 资源的访问，AWS 根用户通过在 AWS 管理控制台上设置这些访问权限。
1. 手动新建一个 IAM 用户：AWS 根用户填写创建用户名及初始密码（或 IAM 随机生成），并通过复制后发送 IAM 自动生成的邮件邀请模版 - 附上Sign-in URL（类似根用户登录界面，但多一行显示是某 IAM 用户的专属登录界面）和User name，而初始password（如果是随机生成的password可以在生成 IAM 新用户过程的最后一页可以通过点击password tab的show按钮看到，记得复制否则关闭后好像不能再找到show按钮）要以除了上面那封邮件的另外的渠道给予被允许使用该 IAM 新用户的人/团体）。
2. 关联已有第三方账号来新建一个 IAM 用户：第三方账号通常分为两类，一类是公司网络用户、微软Active Directory（最好兼容SAML2.0），一类是Internet 身份提供商（如 Login with Amazon、Facebook、Google 或任何与 OpenID Connect (OIDC) 兼容的身份提供商）（但 AWS 根用户貌似不可）。
IAM 用户的使用者不一定是真实的个人或团体，也可以是机器、程序，因此在新建 IAM 用户时其中有一步是选择该用户是纯粹通过程序途径（比如API）访问、操作 AWS 服务及资源还是也可以登录 AWS 管理控制台页面以访问、操作 AWS 服务及资源。

IAM 甚至可以精细权限，比如可以针对不同资源向不同人员授予不同权限，比如允许某些用户完全访问 EC2、S3、DynamoDB、Redshift 和其他 AWS 服务，对于另一些用户，可以允许仅针对某些 S3 存储桶的只读访问权限，或是仅管理某些 EC2 实例的权限，或是访问根用户的账单信息但无法访问任何其他内容的权限。
也可以使用 IAM 设置在 EC2 上运行的应用程序哪些 AWS 服务、资源（比如 S3 存储桶，DynamoDB 表）有哪些访问权限。



https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html  
AWS STS服务：  
这是一个临时性的密钥，是有时间、IP限制的，通常这是绑定了IAM的某个权限角色的用户的。



https://docs.aws.amazon.com/IAM/latest/UserGuide/console_sign-in-mfa.html  
使用 MFA 设备访问 IAM 登录页面：  
AWS 根用户可以配置以强制要求 IAM 用户使用其 MFA（多重要素验证）设备登录 AWS 管理控制台。在用户键入用户名和密码后，AWS 将检查用户的账户以查看该用户是否需要 MFA。如果需要，则将显示另一个具有 MFA code 框的登录页面，以便输入 MFA 令牌设备提供的数字代码或以 SMS 文本消息形式发送到用户的移动设备的数字代码。


