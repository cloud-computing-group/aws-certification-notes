## A Cloud Guru
  
### 什么是 AWS Macie
这是一个安全相关的服务，它使用机器学习来自动发现、分类以及保护你在 AWS 上的敏感数据。  
这是一个由 AWS 完全管理的服务：  
* 可以从数据中识别任意个人识别信息（PII）或知识产权
* 提供 dashboard 展示信息如何被访问或挪移
* 监控不规范数据访问行为
* 当察觉有非认证访问或数据意外泄漏风险时，发出细节警告
* 目前只服务 S3 中的数据，未来会为更多其他 AWS 服务的数据提供服务
* 让你更好地观测你的数据
* 该服务也很容易设置、管理  
  
### Lab
步骤：  
1. 启用 Macie（目前该服务只提供给有限的几个 Region）
2. Dashboard 可以查看当前的警告信息，最低风险设置，S3 的选择时间段
3. 搜索、Users 及其他设置  