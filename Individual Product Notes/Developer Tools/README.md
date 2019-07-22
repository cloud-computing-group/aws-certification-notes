### CodeCommit
AWS 提供的 Source Control 服务，用于创建 repo 、存放代码、二进制文件、图片、库等等，可以设置使用 git（完整支持），设置多与 GitHub 相似比如创建 credential 用于 git 命令链接到你的代码仓库，具体需要到 IAM 到具体 User 下的 credential 创建页面（该 User 需先获得/添加 CodeCommit 整体的访问权限 - AWSCodeCommitFullAccess，具体需设置 IAM policy），最下方有创建 CodeCommit 的 git credential 选项（即获取一对账号与密码，就如普通 IAM 用户设置 credential 那般）。  
也可以返回代码仓库地址方便你 git clone（clone 时需要输入上面的 credential）(git clone 与 Github 一样可以选 HTTPS 或 SSH，在 Connection Steps 里选)。然后剩下的就是本地使用 git 一样，写代码然后 add、commit、push（第一次 push 也需要输入一次刚刚的 credential，应该是检查你是否有写权限）等等（除了本地编码然后 push，你也可以和 GitHub 一样在 CodeCommit 上创建和编码、编辑文件，除此之外还可以和 GitHub 一样在网页上创建分支、提交 PR 等等）。  
在数据传输过程（HTTPS/SSH）中已加密。因此安全且高度可扩展。另外还可以设置 SNS 提示以检查任何 CodeCommit 的事件（比如有人提交 PR）。  
  
### CodeBuild
* 一个完整管理的 build 服务
* 编译你的代码
* 跑单元测试
* 产生准备好部署的 Artifacts（如 JAR、.out、二进制）可执行文件
* 无需你对 build 服务器进行服务开通、管理、扩展等不必要的工作（与 Travis CI 在 build 时自己管理它们的 VM 一样）
* 提供预先打包、准备好的 build 环境
* 允许你 build 你自己的自定义 build 环境
* 自动扩展以满足你的 build 需求  
三个优点：1. 自动完整管理；2. On Demand 按用（build 花的时间）付费；3. 预先配置、打包、准备好环境。  
用例过程：  
1. Build Project 命名等，选择 Source Provider（可以是 CodeCommit 也可以是其他平台如 GitHub）及其代码仓库
2. 设置 build 环境（这里可以手动选择 AWS 平台的容器镜像或自定义容器镜像，然后选择比如操作系统、语言环境、版本，最后选择/添加 AWS role，上传/选定 buildspec.yml 文件类似 .travis.yml 文件，添加最后生成的 Artifacts 文件的存储路径比如 S3，等等）
3. 然后创建一个 build project，每次需要 build 以产生可执行文件时，可以对该 project 手动点击 start build 也可以设置 build 的触发机制（如周期性的）
  
### CodeDeploy
AWS 管理的部署服务，可自动部署代码、文件至：  
* EC2 实例
* On-premises 实例
* Lambda functions  
简化了：  
* 快速部署新特性
* 更新 Lambda function 版本
* 避免在部署时遭遇宕机
* 不受人为影响的处理复杂的部署过程  
过程需要设置正确的 IAM Role（AWSCodeDeployFullAccess），一个给 EC2 实例使用（还需要 S3 访问权限），一个给 CodeDeploy 使用。以下过程是通过控制台向导执行的，但也可以通过 AWS CLI 完成。  
1. 创建 ELB（ALB）
2. 启动多个 EC2 实例（使用前面的 Role，安装并运行 codedeploy-agent server）并放入 Auto Scaling Group
3. CodeDeploy 面板，应用命名，选择计算平台（比如 EC2 实例）
4. 选择 deployment 组，选择 Role（前面的 IAM Role），部署类型（In-place 或 Blue/green），环境设置（此案例选择 Auto Scaling Group，即部署至此 Auto Scaling Group 后面的 EC2 实例，如果只有 EC2 实例没有 Auto Scaling Group 可以直接通过 tag/key 选 EC2 实例们），设置/选择负载均衡（此案例为前面的 ELB/ALB），完成创建 deployment 组
5. Create deployment（revision type 可以是 GitHub 但此案例为 S3 bucket，即要部署的代码、文件源）（同时这里也可以设置 rollback 机制以及相关部署额外、情景动作等等），点击开始部署，等待完成，这个过程可以监控查看部署过程的所有事件
6. （设置好 DNS 给 ELB 后）浏览器访问 ELB 地址，就可以看到被部署的 web 应用、程序运行并显示网站了  
PS：  
可以与其他 CICD 工具（如 Jenkins、Atlassian）以及配置管理工具（如 Ansible、Puppet、Chef）集成。  
案例里在部署的代码里的 appspec.yml（deployment process 相关的 yml 文件）写了在实例运行或终止时运行或终止 nginx 的配置文件、脚本，因此才能显示、托管上面的 web 应用。(https://docs.aws.amazon.com/zh_cn/codedeploy/latest/userguide/reference-appspec-file.html)  
  
一些用语：  
* Deployment Group - 新开通的用于搭载新版本应用、程序的实例们。
* Deployment Configuration - 一组部署 rules 以及在部署中使用的成功、失败条件。
* AppSpec File - 定义你希望 AWS CodeDeploy 执行的部署动作。
* Revision - 部署新版本需要的所有东西：比如 AppSpec File、应用文件、可执行文件、配置文件等等。
* Application - 你想部署的唯一标识的应用。用来确定正确的 revision 组合、部署配置以及目标 deployment group。
  
考点：  
In-Place 与 Blue/green 部署：https://docs.aws.amazon.com/zh_cn/codedeploy/latest/userguide/deployments.html  
In-Place（或称 Rolling Update） 只支持 EC2 和 On-premise，不支持 Lambda。更新程序、应用的策略是现在全部硬件上的程序、应用按顺序一一停止（暂停服务且应预先设置负载均衡策略跳过这个硬件与应用，这意味着此时 capacity reduce 了）并更新（前一个完成更新并重新运行、上线后再停止并更新下一个）。Rollback 则要求 re-deploy 旧版本，所以要花些时间。  
Blue/green 服务开通新的硬件并跑上新版本的程序、应用，根据你设置的 schedule 策略逐渐把旧硬件上的旧应用服务的流量切换、导向新硬件与新应用（流量切换由负载均衡负责），所以旧硬件旧应用完全不受影响，完成后把所有旧硬件关停删除。Rollback 非常简单只需把流量导回原先的旧硬件、应用上（如果旧硬件们还未删除则直接用旧硬件群 Blue，否则开新的硬件群 green 以搭载旧版本应用）。支持 EC2、On-premise 以及 Lambda。（所以 Blue/green 相比 In-Place 更快且更稳定。这里 Blue 即是当前、旧版本的部署，green 则是新版本、新发布的部署）  
  
### CodePipeline
AWS 自动管理的 CICD 服务，它全自动、易用、可配置（添加自动测试、自定义部署过程）。可以设置为在每次仓库代码更新时编排一整次 Build、测试、部署操作。你可以通过它自定义发布的 workflow 或由不同任务组成的 pipeline，可以与 CodeCommit、CodeBuild、CodeDeploy、CloudWatch、Lambda、Elastic Beanstalk、CloudFormation、ECS、GitHub、Jenkins 等等服务进行集成。  
1. Pipeline 设置、命名，选择 Role，Artifacts 存储路径，选择 Source Provider 及其代码仓库以及仓库分支，选择 detection 选项（比如 CloudWatch 可以监测代码仓库分支是否有更新，一旦发现更新则触发一次基于此 Pipeline 的 CD）
2. 添加 build stage
3. 添加 deploy stage（比如选择之前的 CodeDeploy 应用和之前创建的 deployment 组）
4. Review 完即可点击创建 Pipeline（首次创建会先部署一次，之后按前面的触发条件自动执行 CICD）  
也可以通过 AWS CLI 完成以上操作。  
  
### Testing
测试通常包含以下几点：能保证满足定义、声明的要求，保证代码在指定时间内执行完成，保证程序可用，保证对所有输入正确响应，达到开发者想要的结果。  
测试类型有多种：  
![](https://github.com/cloud-computing-group/aws-certification-notes/blob/master/Individual%20Product%20Notes/Developer%20Tools/Test%20Types.png)
  
#### 自动测试
自动执行测试，对比实际输出与预估输出，快速、持续地反馈，实时提示信息，节省资源、时间。自动测试可以包含单元测试。  
在 CodePipeline 添加测试：  
1. 点击编辑某个 Pipeline，Add stage（命名 stage 为 Test）
2. 点击刚刚创建的 Edit:Test -> Add action group 的 Action provider（此处还可以添加让其他人 approve 此 action 的功能）添加测试项  
  
### Artifacts
1. 点击编辑 CodeBuild 的一个 build project 的 Artifacts
2. 更新、设置 build 完成之后 Artifacts 放置的路径（比如 S3 bucket，但 S3 可能不安全因此需注意 policy 以及 ACL 等等），还可以选择压缩、加密 Artifacts 文件
3. 还可以选择不输出 Artifacts 文件，而是创建一个 Docker 容器镜像放置在 AWS ECR 上以便让 ECS 使用  
PS：AWS 平台本身有个服务叫 AWS Artifact（该服务提供按需访问一些 AWS 的 compliance 报告），与这个 Artifacts 没有任何关系。  
  
### AppSpec
