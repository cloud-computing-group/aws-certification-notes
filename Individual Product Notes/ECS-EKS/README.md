## 官网文档
Amazon Elastic Container Service 是一种高度可扩展的高性能容器编排服务，类似Kubernetes。  

ECS 的使用应结合 CI 工具（比如 Jenkins、Travis CI等）、版本控制工具（如 GitHub）、容器工具（支持如 Docker、容器Registry）。  
ECS 的工作内容是关于如何创建和部署微服务系统中的某个服务的容器或容器群、roll back、以及被设置成可以自动扩展增加容器以应对激增流量的需要也可以在流量少的时段删除不必要的容器以减少资源的浪费等等。  
ECS 里一个Cluster（集群）可以有多个服务，每个服务会有多个任务（task），task即容器的版本、代码的版本。  
ECS 可以设置最小健康容器比例以及最大容器比例（可以高于流量需要）来如何按百分比更替旧版本的容器（基于GitHub的相关仓库的版本更新时）。   

### ECS有两种方式创建容器：  
1. 使用 AWS Fargate 创建容器，即无需开发者自己管理创建服务器（AWS EC2）即可部署和管理容器，容器将运行在 AWS 的中央平台上如 AWS Lambda。使用 AWS Fargate 的好处是方便灵活，开发者只需要专注于代码与业务，无需管理服务器。
2. 使用 AWS EC2，ECS在创建了 EC2 实例的基础之上，再在 EC2 里运行容器。好处是比 AWS Fargate 便宜，并且可以设置 IP 限制等服务器操作。  

KMS 可以为 ECS 提供密钥管理服务。  
另外， AWS 已推出基于 Kubernetes 的 EKS，开发者可以自行决定是使用 ECS 还是 EKS 作自己的容器编排管理。  
  
### 题外话：  
微服务中一般每个服务对应一个写入数据库，即某个服务的Docker集群都是写入一个数据库的，而只读数据库则有一个或多个，写入数据库与只读数据库成主从关系，在 AWS 中，可以由 AWS RDS 内置功能、服务（Multi-AZ Deployments）自动实现主从数据库之间的实时数据同步。一般每个服务至少一个写入数据库和一个只读数据库，因为只读数据库又是副本数据库，在写入数据库（主数据库）出现错误或崩溃的情况下可以被立即替换成主数据库。  
  
## A Cloud Guru
  
### Overview
* 高可扩展
* 快速
* 在集群上管理容器
* 支持 API 调用（比如启动、停止某个容器应用）
* 支持 Scheduling
  
Architecture of ECS objects:  
```json
[
    {
        "Cluster": [
            {
                "Service": {
                    "Task Definition": [
                        {
                            "Container Definition": {
                                "Container Name": "String",
                                "Image": "String",
                                "Memory Limits": "Int",
                                "Port mapping": "Int"
                            }
                        },
                        {
                            "Container Definition": []
                        }
                    ]
                }
            },
            {
                "Service": []
            }
        ]
    },
    {
        "Cluster": []
    }
]
```
* Container Definition - 比如为容器选择或自定义一个镜像，CPU、内存要求等等。
* Task - 如何部署多个容器到一个集群里的多个 EC2 实例。
* Task Definition - 某个 Task 的 template（即方便自动、可复用运行的模版，可以是 JSON 格式声明），包括一个或多个容器，声明里的属性、元数据有些是 task level 的，但大多数属性、元数据是 container level 的（比如上面的 Container Definitions，与其他容器的通信以及网络、端口设置，data storage volumes 设置，IAM role 等等，最后都会在 Run-Task 时通过发送这些元数据或结合相关指令给 Docker Daemon 进行具体实现、操作、启动容器）。
    * Docker Image - Point on time capture (版本) of code and dependencies
    * Task Definition - Point on time capture (版本) of the configuration for running the image
* Service - 一个 Service 可以让你在一个 Cluster（集群）里同时运行一个 Task Definition 的一个或多个实例（即 Task）。（这里可以设置负载均衡，设置好后会返回负载均衡的 IP 地址）（自动化 Run-Task 执行，管理、维护 Task 的比如 Long-Running Workloads、长时间保证运行某个 Task 不间断 - 因为 Service 可以提供如实时监测 Task 比如 Task 被检测到 fail 了会重启，制定 Task Placement 策略 - 定义如何将 Task 高效、合理地分配在集群上比如分布到跨多个 Availability Zone 多个 EC2 实例、分配 Task 到可用硬件上、考虑到单个宕机对稳定性影响因此每个 EC2 实例只运行一个 Task，以及进行 Task 更新、替换 - 会仍旧运行旧 Task 直到新 Task 被检测确认为 healthy、稳定的 - 另外还可以设置比如替换速度、无缝程度，Task 因故障、报错而重启、替换的机制）（其实你在 ECS 控制台上手动 Run-Task 时即可以被认为是运行了一个简化版的 Service）。
* Cluster（集群） - 基础设施（即一组开发者自己管理、配置、开通的用于运行容器的 EC2 实例、VM、硬件以及相关网络如 VPC 的管理等等，如果是 Fargate 集群的话这些硬件及网络则完全由 AWS 自动管理）（除了普通 EC2 实例还可以利用、使用 On-Demand、Spot、Reserved 实例以降低成本同时又保证效用，另外要注意集群的每个 EC2 实例是运行在其被指定的 Region 的）（创建集群可以通过控制台的向导进行创建，包括选择实例类型、数量以及设置 VPC 和 SSH 的 Key 等等，也可以通过 CloudFormation 或 ECS CLI 或 ECS API 创建）。  
https://aws.amazon.com/cn/ecs/getting-started/  
https://docs.aws.amazon.com/zh_cn/AmazonECS/latest/developerguide/ECS_clusters.html  
https://docs.aws.amazon.com/zh_cn/AmazonECS/latest/developerguide/ecs_services.html  
https://docs.aws.amazon.com/zh_cn/AmazonECS/latest/developerguide/task_definitions.html  
  
ECS Agent：  
管理及向 ECS 报告单个实例上的容器们的状态，是 ECS 与单个实例上的 Docker Daemon 通讯（比如下指令该实例运行更多容器）的桥梁，每个实例上都应该安装有一个 ECS Agent。具体实现安装该 Agent 的方式是 ECS 启动、开通一个新实例时基于一个叫 ECS-OPTIMIZED AMI 创建该实例（即不用 SSH 到该实例来手动安装那么麻烦）。  
  
集群 Dashboard：  
列出 Services 列表，可以查看单个 Service。Service 里有 Tasks（比如正在运行的 Task），Event（比如 Service 状态更新），Deployment，Metrics，Logs（比如来自 ELB health check 的 HTTPS 请求）  
