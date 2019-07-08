# A Cloud Guru
  
## SDLC Automation
SDLC 即 software development life cycle:
* Version control
* Code build / compile
* Testing
* Pipeline
* CI/CD
  
## CI/CD 好处
* Build 更快
* 减少 Code review 时间
* 自动化
* 更快的错误隔离、排查
* 额外的 deployment 特性
  
## CI/CD Pipeline
Source Stage (AWS CodeCommit) -> Deploy Stage (Development) (AWS CodeDeploy -> AWS EC2) -> Deploy Stage (production) (AWS CodeDeploy -> AWS EC2)  
以上都可由 AWS CodePipeline 帮忙管理。  