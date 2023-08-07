# 白皮书
https://d1.awsstatic.com/whitepapers/DevOps/running-containerized-microservices-on-aws.pdf  
https://d1.awsstatic.com/whitepapers/microservices-on-aws.pdf  
https://d1.awsstatic.com/whitepapers/DevOps/infrastructure-as-code.pdf  
https://d1.awsstatic.com/whitepapers/DevOps/practicing-continuous-integration-continuous-delivery-on-AWS.pdf  
https://d1.awsstatic.com/whitepapers/DevOps/Jenkins_on_AWS.pdf  
https://d1.awsstatic.com/whitepapers/DevOps/import-windows-server-to-amazon-ec2.pdf  
https://d1.awsstatic.com/whitepapers/AWS_Blue_Green_Deployments.pdf  
https://d1.awsstatic.com/whitepapers/AWS_DevOps.pdf  
https://d1.awsstatic.com/whitepapers/aws-development-test-environments.pdf  

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
  
## Deployment Strategies
* Single Target Deployment : Build -> Target
    * 适用于开发小的项目，尤其是引入了一些遗留的或非高可用的基础设施架构
    * 当初始化一个新应用版本到一个目标服务器上
    * 安装期间遭遇普遍 outage。没有第二个服务器，因此测试过程被限制了。回滚要包括了移除新版本并安装回旧版本
* All-at-Once Deployment : Build -> (Multiple) Target
    * 部署步骤只发生一次，如 Single Target Deployment 一般
    * 但是该部署方式最终部署至多个目标
    * 比 Single Target Deployment 复杂因为需要编排工具
    * 与 Single Target Deployment 的不足之处一般，不能做测试，会有部署 outage，回滚也不理想
    * 此方式只适合部署不要紧的应用
* Minimum in-service Deployment : (告诉编排引擎有至少或最佳要多少目标执行，系统保证这个数量总是处于激活状态并在部署完成后尽快响应健康检查)
    * 步骤：
        * Initial Build Stage，比如 5 个目标、实例（运行着旧版本）在不同 AZ
        * 部署阶段一，根据被告知的最少或最佳保持运行 2 个目标，因此另外 3 个开始部署新的版本
        * 部署阶段二，阶段一部署完后，部署剩下的 2 个目标，此时有 3 个目标运行（且已通过健康检查）所以满足最少、最佳运行目标数
        * 部署阶段三，5 个目标全部部署完成且健康检查完，新版本总体部署完成
    * 部署发生在多个阶段
    * 一次部署尽量多的目标，同时尽量维持 Minimum in-service 的目标数
    * 几个 moving part，要求有编排与健康检查，因此需要基础实施架构参与，所以只会在大型环境中使用或部署成为团队的重要问题
    * 支持自动化测试，目标会被先访问与测试再继续进行部署
    * 没有 down time
    * 比 rolling deployment 更快且更少步骤
* Rolling Deployment : (极好的自动化与编排，与 Minimum in-service Deployment 类似，不同的只是每阶段都按指定数量目标进行部署)
    * 部署发生在多个阶段，每次部署的目标数量按你指定的执行
    * moving part，要求有编排与健康检查，健康检查结果可以定义后续动作（比如暂停、fail 掉此阶段、回滚整个部署等等）
    * 不一定维持整体可用性健康（只要有编排引擎，部署的健康检查只针对某个目标，但现今较为先进的引擎可以观察应用架构的全局的健康、状态，因此可基于此在部署中进行后续决策）
    * 基于时间上这是最低效的部署方式
    * 支持自动化测试，目标会被先访问与测试再继续进行部署
    * 基本没有 down time
    * 部署过程可以暂停，结合每阶段部署少量的目标可以允许有限的多版本测试
    * 多数应用、配置管理、编排引擎支持此方式
    * 最低风险且最低成本的部署方式（在公有云上按小时或分钟收费）
* Blue Green Deployment : (完全启动同数量的新版本目标，检查没问题后由 Route53 更新 DNS 路由，然后关停所有旧目标。此方法对 outage 与应用性能影响风险)
    * 要求先进的编排工具
    * 收费较高，因为要在部署过程中维持两个环境
    * 部署速度快，整个新版本一次性部署完
    * 迁移简易，仅仅是 DNS 更新
    * 回滚简易，仅仅是 DNS 更新
    * 整个新环境的健康及性能检查会在迁移前完成
    * 使用先进的模版系统，比如 CloudFormation，整个部署过程可以完全自动化
* Canary Deployment
    * 和 Blue Green Deployment 基本一样，不同的是新版本启动检查完后不是直接把 DNS 全转进新版本，而是按比例地分配，意味着旧版本仍在工作
    * 随着时间和开发者的设置（Route 53 weighted round robin），流量比例最终慢慢都增加、迁移至新版本，最后再关停旧版本
    * A/B 测试  
  
## Tagging
* 一种标签，可以赋给一个 AWS 资源
* 由键和值组成
* 一个键可以有多个值  
  
### 好处
    * 组织你的资源
    * 跟踪你的支出、费用  
  
### Access Control
    * 可以结合使用 IAM Policies 里的 Condition（即通过 tag 控制对资源的访问）  
用例：  
```yaml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:StartInstance",
                "ec2:StopInstance"
            ],
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "StringEquals": {"ec2:ResourceTag/Owner": "${aws:username}"}
            }
        },
        {
            "Effect": "Allow",
            "Action": "ec2:DeleteInstance",
            "Resource": "*",
            "Condition": {
                "StringLike": {"ec2:ResourceTag/Owner": "admin"}
            }
        }
    ]
}
```
  
### Cost allocation tags
有 2 种：  
1. AWS-Generated Cost Allocation Tags
2. User-Defined Cost Allocation Tags  
  
* 在 Billing 控制台启用
* 基于 tag，AWS 生成一个 cost allocation 报告（可导出到 S3）
    * CSV
    * 通过 active 的 tag 分组
* 为所有应用的资源打上 tag 以检查运行应用时支出、费用都发生在哪里  
  
### AutoScaling and Lifecycle hooks
按照你的配置定义自动扩展 EC2 实例，比如通过 CloudWatch 监测 CPU、内存使用率并根据其数据触发扩展。  
  
Auto Scaling Lifecycle：  
1. 开始于当 Auto Scaling Group 启动开通一个实例时
2. 结束于关停一个实例时
3. 结束于 Auto Scaling Group 将一个实例抽出服务群并将其关停时  
  
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/default/Certifications/Professional/DevOps/Auto%20Scaling%20Lifecycle.png)  
上图的黄色块即 Lifecycle Hook，Lifecycle Hook 允许你在该 Hook 的特属时段内进行一些自定义动作，触发动作如在 Pending Hook 安装软件或在 Terminating Hook 复制并备份实例日志数据。  
  
Lifecycle Hook 是如何工作的：  
1. Auto Scaling 响应一个扩展事件、请求，开通启动一个实例
2. Auto Scaling 将实例放入 Pending:Wait 状态
3. Auto Scaling 发送消息（包含信息及 token）给 Hook 定义的通知目标
4. 等待直到被告知继续还是超时结束
5. 现在可以执行你的自定义动作，比如安装软件等等
6. 默认情况下，实例会等待一小时然后更新状态至 Pending:Proceed，然后再进入 InService 状态，如果想要更多时间你可以更改默认等待时间或如下面的 Notes 里第3条  
  
Notes：  
* 你可以更改 heartbeat timeout，或者你可以在创建 Lifecycle Hook 时通过 CLI 定义 heartbeat timeout
* 你可以调用 complete-lifecycle-action 命令以告诉 Auto Scaling Group 继续
* 你可以调用 record-lifecycle-action-heartbeat 命令以为 timeout 增加时间
* 48 小时是你可以保存实例、服务在 Wait 状态的最大时间，不管 heartbeats 怎么样  
  
Cooldowns：  
* 帮助确保 Auto Scaling Group 没有启动、关停过多的实例
* 开始于当实例进入 InService 状态时，所以当实例还留在 Pending:Wait 状态即你对其执行函数时，Auto Scaling 会继续等待并在此之后才会增添额外的服务器  
  
状态 Abandon 或 Continue：  
* 在一个 Lifecycle Hook 的总结里，一个实例最终可能是状态 Abandon 或 Continue
* Abandon 意味着实例失败，将导致 Auto Scaling Group 关停此实例并酌情考虑重新开通启动一个新实例
* Continue 意味着实例成功，会在之后将实例放入服务群中  
  
Spot 实例：  
* 你可以对 Spot 实例使用 Lifecycle Hook
* 但不能阻止实例因为 Spot price 变更而被关停
* 当 Spot 实例关停时，你必须仍完成 Lifecycle 动作  
  
## ELB 集成 ASG（Auto Scaling Group）
1. 首先先创建 ELB（包括设置 EC2 实例的 health check）
2. 创建 ASG 的 Launch Configuration
3. 创建 ASG（设置其关联的 ELB，health check type 设置为 ELB 即使用 ELB 的 health check 策略）
如此 ASG 就会定期按照 ELB 的 health check 检查 ASG 内的 EC2 实例，如果某个实例出现问题则另起新实例，ELB 则会自动将负载分配给 ASG 内的这些实例（无论新旧）。  
  
## CloudFormation vs OpsWorks vs Elastic Beanstalk
CloudFormation 更关注于 AWS 云资源或基础设施上的服务开通、部署或更新，OpsWorks 更关注于配置方面（如操作系统、应用等层面的安装、更新）但也可用于云资源的服务开通、部署（如 ELB、ASG、EC2、RDS 等等），EB 则让开发者更多关心应用、代码的开发而无需操心云资源的管理与部署。  
  
相比 CloudFormation，OpsWorks 除了可以服务开通、部署，还可以做 ongoing changes，所以当你需要做的是部署应用程序并更新其相关实例时，你应该使用后者 - OpsWorks。  
当你的企业应用将使用大量 AWS 云资源或服务（包括 EC2）时，你应该同时结合使用 CloudFormation 与 OpsWorks（可以编写在 CloudFormation 里）。  
结合使用 CloudFormation 与 OpsWorks 场景：在 CloudFormation 里开通、部署云资源与服务，通过 OpsWorks 对操作系统或基础设施做细节配置；在 CloudFormation 里更新云资源、服务、基础设施，通过 OpsWorks 更改如操作系统、应用程序。  
使用 EB：你可能需要一些额外的云服务或不受 EB 管制的数据库，那你可以通过 CloudFormation 来配置管理、部署 EB 及那些与 EB 解耦的云服务。  
（https://searchaws.techtarget.com/tip/When-to-use-AWS-OpsWorks-vs-CloudFormation-or-Elastic-Beanstalk ）  
  
OpsWorks 支持 Chef 与 Puppet，但不支持 Ansible。  
Chef / Puppet / Ansible 是自动化运维，减少手工运维，使用 DSL 或 YAML 来进行配置 - 简单明了友好，又或添加了更多的标准、规范从而使得不同组、人员都能配置得更加一致、安全、有保障，又或有更高级的 Declarative configuration 即声明式运维（https://my.oschina.net/zjzhai/blog/600430 ）与普通 shell 脚本不同其可在单个命令里可能已经集成多个 shell 命令，从而省却了许多 shell 的重复工作且自动处理执行错误失败等情况。题外话，可以把 Docker 当作一个更先进的声明式运维。  
关于 shell 与 Chef / Puppet / Ansible 的相似与对比（http://www.voidcn.com/article/p-tofzyzje-btv.html ）  
  
  
  
## 更多
关于高可用性：https://zh.wikipedia.org/wiki/%E9%AB%98%E5%8F%AF%E7%94%A8%E6%80%A7  
  
## Exam Tips
https://d1.awsstatic.com/whitepapers/DevOps/practicing-continuous-integration-continuous-delivery-on-AWS.pdf  
Continuous Integration 是关于代码集成、合并的，是高频率更新且允许多人在同一个应用项目、代码仓库上工作、推送更新的。  
Continuous Delivery 是关于自动化 build、测试以及部署方法。  
Continuous Deployment 是关于完全自动化整个发布过程，当代码成功通过 pipeline 后会立即部署到产品上去。  