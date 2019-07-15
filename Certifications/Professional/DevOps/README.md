# A Cloud Guru
  
## SDLC Automation
SDLC 即 software development life cycle:
* Version control
* Code build / compile
* Testing
* Pipeline
* CI/CD
  
## CI/CD（Continuous Integration & Continuous Delivery/Deployment）好处
* Build 更快
* 减少 Code review 时间
* 自动化
* 更快的错误隔离、排查
* 额外的 deployment 特性
  
## CI/CD Pipeline
Source Stage (AWS CodeCommit) -> Deploy Stage (Development) (AWS CodeDeploy -> AWS EC2) -> Deploy Stage (production) (AWS CodeDeploy -> AWS EC2)  
以上都可由 AWS CodePipeline 帮忙管理。  
  
## Exam Tips
https://d1.awsstatic.com/whitepapers/DevOps/practicing-continuous-integration-continuous-delivery-on-AWS.pdf  
Continuous Integration 是关于代码集成、合并的，是高频率更新且允许多人在同一个应用项目、代码仓库上工作、推送更新的。  
Continuous Delivery 是关于自动化 build、测试以及部署方法。  
Continuous Deployment 是关于完全自动化整个发布过程，当代码成功通过 pipeline 后会立即部署到产品上去。  