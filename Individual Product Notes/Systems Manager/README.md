## A Cloud Guru
  
### AWS Systems Manager Parameter Store
场景：你在银行里做系统管理，你需要保存机密信息如用户、密码、许可证 Key 等等。这些信息需要传递给 EC2 实例比如进行一些启动脚本，但有用同时保证信息安全不外泄。因此 AWS Systems Manager Parameter Store 帮助你做到这点。  
AWS Systems Manager Parameter Store 没有自己的控制台，但是你可以在 EC2 的控制台找到它（Systems Manager Services 与 Systems Manager Shared Resources）。  
1. Systems Manager Shared Resources 选择 Parameter Store，此服务可以用于创建、保存、跨服务跨平台引用敏感信息（比如在自动化中引用敏感信息）。
2. 创建 Parameter，可以选择 Parameter 类型，有纯字符串、字符串数组不加密类型，还有 Secure String - 即应用 KMS 对数据自动进行加密/解密（因此使用时引用 Parameter Name 即类似程序里使用变量名即可，而该 Parameter 的数值只有创建者或权限者知道）。  
Systems Manager Parameter Store 支持的服务有：EC2、CloudFormation、Lambda、EC2 Run Command 等等。  
  
更多参考：https://docs.aws.amazon.com/zh_cn/systems-manager/latest/userguide/sysman-paramstore-working.html