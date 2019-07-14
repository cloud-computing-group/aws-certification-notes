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
* Container Definition - 为容器选择或自定义一个镜像。
* Task Definition - 应用的蓝图，包括一个或多个容器，声明的属性有些是全 task 的，但大多数属性是每个容器有单独配置的。
* Service - 一个 Service 可以让你在一个 Cluster（集群）里同时运行一个 task 的一个或多个实例。（这里可以设置负载均衡，设置好后会返回负载均衡的IP地址）。
* Cluster（集群） - 基础设施（比如一堆开发者自己管理、配置的 EC2 实例以及网络，如果是 Fargate 集群的话则完全有 AWS 自动管理）。  
https://docs.aws.amazon.com/zh_cn/AmazonECS/latest/developerguide/ECS_clusters.html  
https://docs.aws.amazon.com/zh_cn/AmazonECS/latest/developerguide/ecs_services.html  
https://docs.aws.amazon.com/zh_cn/AmazonECS/latest/developerguide/task_definitions.html  

集群 Dashboard：  
列出 Services 列表，可以查看单个 Service。Service 里有 Tasks（比如正在运行的 Task），Event（比如 Service 状态更新），Deployment，Metrics，Logs（比如来自 ELB health check 的 HTTPS 请求）  
