IAM（永久免费）使AWS用户能够安全地管理对 AWS 服务和资源的访问。AWS 根用户可以使用 IAM 创建和管理 AWS IAM 用户和组，并使用各种权限来允许或拒绝他们对 AWS 资源的访问，AWS 根用户通过在 AWS 管理控制台上设置这些访问权限。
1. 手动新建一个 IAM 用户：AWS 根用户填写创建用户名及初始密码（或 IAM 随机生成），并通过复制后发送 IAM 自动生成的邮件邀请模版 - 附上Sign-in URL和User name，而初始password（如果是随机生成的password可以在生成 IAM 新用户过程的最后一页可以通过点击password tab的show按钮看到，记得复制否则关闭后好像不能再找到show按钮）要以除了上面那封邮件的另外的渠道给予被允许使用该 IAM 新用户的人/团体）。
2. 联合现有用户：



AWS STS服务：
这是一个临时性的密钥，是有时间、IP限制的，通常这是绑定了IAM的某个权限角色的用户的。



Using MFA Devices With Your IAM Sign-in Page
AWS 根用户可以配置以强制要求 使用MFA（多重要素验证）设备


