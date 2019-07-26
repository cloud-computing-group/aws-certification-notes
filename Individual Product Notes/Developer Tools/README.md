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
这个文件是用来定义 CodeDeploy 部署时的参数。文件结构取决于你是部署至 Lambda 还是 EC2 / On Premises。  
  
#### AppSpec Lambda
如果是 Lambda 部署，AppSpec 文件的数据格式应是 YAML 或 JSON，且包括以下字段：  
* version - 可能在未来用上的保留关键字，目前只有一个值即 0.0
* resources - 部署的 Lambda 函数的名字以及属性
* hooks - 部署时指定 Lambda 函数运行在设定点上以验证部署，比如在新部署上线前保证测试、验证通过。  
AppSpec File - Hooks - Lambda：  
* BeforeAllowTraffic - 用来指定在部署正式上线前你想执行的任务或函数（如测试验证函数被正确部署）
* AfterAllowTraffic - 用来指定在部署正式上线后你想执行的任务或函数（如测试验证函数正确地接收请求、流量并如预期响应、处理）  
  
#### AppSpec EC2 / On Premises
如果是 EC2 / On Premises 部署，包括以下字段：  
* version - 可能在未来用上的保留关键字，目前只有一个值即 0.0
* os - 操作系统及版本你想运行在服务器上（比如 Linux、Windows）
* files - 应用文件应该存放在服务器上的位置、路径
* hooks -   生命周期事件 hooks，允许你在部署生命周期中指定将在设定点运行的脚本（比如在部署前解压应用文件、在新部署应用上运行函数测试、在负载均衡上取消或重新注册服务器实例）  
在 EC2 / On Premises，AppSpec File 必须放置在上传的应用文件的根路径上。  
  
AppSpec File - Hooks - EC2 / On Premises（以下顺序是按生命周期排序的 - Run Oder of Hooks）：  
* BeforeBlockTraffic - 在实例在负载均衡取消注册前，在实例上运行任务
* BlockTraffic - 从负载均衡上取消注册实例
* AfterBlockTraffic - 在实例在负载均衡取消注册后，在实例上运行任务
* ApplicationStop - 渐停应用以准备部署新的版本
* DownloadBundle - CodeDeploy Agent 下载新版本文件到服务器临时路径
* BeforeInstall - 安装的前置脚本、动作（比如备份旧版本、文件解码）
* Install - CodeDeploy Agent 将下载到临时路径的新版本文件转到服务器安装路径
* AfterInstall - 安装后脚本，比如配置任务、更改文件权限
* ApplicationStart - 重启那些在 ApplicationStop 过程中被停的服务
* ValidateService - 测试、验证服务的细节、信息
* BeforeAllowTraffic - 在实例被注册到负载均衡之前运行的任务、动作
* AllowTraffic - 在负载均衡上注册实例
* AfterAllowTraffic - 在实例被注册到负载均衡之后运行的任务、动作
  
  
### Docker and CodeBuild Lab
使用 CodeBuild 来 Build Docker 镜像（如同手动 CLI 那样）。  
  
首先先在不使用 CodeBuild 的情况下手动 CLI （需要先在相关电脑或实例上 setup 你的 AWS CLI 及其 Credential Helper）试着在 ECS 上 Build 及使用一个容器镜像（本路径的 Docker and CodeBuild 文件夹内有实践用的一些源代码及命令文件）：  
先要创建一个 ECS 集群来运行镜像每次版本的容器（本例在创建集群时选择 `EC2 Linux + Networking` 集群模版，在此例仅配置给集群一个 EC2 micro 实例即可）。  
创建一个 ECR 仓库来 Build 以及管理 Docker 镜像（其实是该仓库的对应 Registry 存放镜像，仓库本身只链接 Registry 或其他信息功能但不包括存放源代码 - 源代码应存放在 CodeCommit 或 GitHub上，Registry 可以对镜像进行版本控制）  
1. CodeCommit 或 GitHub 新建一个仓库并上传源代码（包含 Dockerfile）
2. ECR 控制台 -> 创建仓库（命名）
3. 选择刚创建好的 ECR 仓库（repository），使用 push commands 用来 push 镜像到你的 ECR registry（此例中的 command 都是在电脑本地运行，你也可以自己另开一单独 EC2 实例、下载好 Docker 进行以下实践）：
    1. 获取 login 命令来给你的 Docker 客户端权限来访问你的 ECR 仓库，使用 AWS CLI 如 `$(aws ecr get-login --no-include-email --region {region_name})` （记得要给使用客户端的相关电脑或 EC2 或 CI 的实例所使用的 IAM Role/User 予相关 ECR 访问 policies）
    2. 使用命令 Build Docker 的镜像，`docker build -t {repo_name} .` （即用 CodeCommit 或 GitHub 仓库里的 Dockerfile 来 build 镜像）
    3. Tag 该新建镜像以方便日后使用 `docker tag {repo_name}:latest 757250003982.dkr.ecr.{region_name}.amazonaws.com/{repo_name}:latest`
    4. Push 镜像到新建的 ECR registry（注意不是 ECR 仓库） 中 `docker push 757250003982.dkr.ecr.{region_name}.amazonaws.com/{repo_name}:latest`，之后你在 ECR 点击该仓库详细信息也能看到新建好的镜像（该镜像列表也保存以前或其他版本的镜像）
4. ECS 集群 -> 创建 Task Definition（启动类型选择 EC2 以及一系列 Task 设置以及增添、附着容器 - 此处即指定上面创建的镜像的仓库的 Registry URI）-> 基于该 Task Definition 创建 Service（完成后在集群里寻找相关 EC2 实例并浏览器访问该实例的 IP 地址即可看到该容器镜像的 web 应用的 index.html 的页面了）  
  
以上的手工步骤也可以由 AWS 全自动执行（通过 CodeBuild）：  
CodeBuild 从 CodeCommit 拿源代码（包含 Dockerfile），然后基于该源代码 build 出一个 Docker 镜像。  
1. CodeBuild 新建 build project，设置 build 环境、source provider、勾选 privileged（build 镜像必须勾选）、勾选使用 buildspec 文件等等
2. CodeBuild 使用本路径的 Docker and CodeBuild 文件夹内的 buildspec.yml 文件自动执行上面的手动工作（记得要给 CodeBuild project 的 IAM Role 予相关的 policies 比如 ECR、CodeCommit 访问权限）（buildspec.yml 文件放在 CodeCommit 或 GitHub 的仓库的源代码文件根目录里，CodeBuild 每次被触发都会自动读取它使用）  
  
#### Exam Tips
* Docker 命令行实现 build、tag（apply 一个 alias）、push Docker 镜像到 ECR 上
* 使用 buildspec.yml 来定义 CodeBuild 的 build 过程，且开发者可以通过在启动时的控制台界面添加自定义 build 命令来覆盖 buildspec.yml 里的命令
* build 过程中可以在 CodeBuild 的控制台检查 build 日志、事件，也可以到 CloudWatch 查看日志  
  
更多可以查看 AWS CICD 的相关白皮书