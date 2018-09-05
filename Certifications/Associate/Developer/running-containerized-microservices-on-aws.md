### 摘要：  
目标读者为打算在 AWS 上运行生产规模级别的容器化应用。  
内容包括：  
1. 应用生命周期管理
2. 安全
3. AWS 上的容器化应用的架构的设计模式（包括讨论最佳实用方案）
另外还介绍传统设计模式在容器化技术影响下的改进历程，以及在基于twelve-factor app pattern（十二要素应用程序）和现实情况下实现应用Martin Fowler的微服务原则。读者将初步学习到软件设计模式以及如何实现一个最佳实用微服务。  



### 介绍：
现代Agile软件开发中，微服务架构与容器化技术越来越普及，且有多种相关的设计模式可供选择。  
微服务（一种软件开发架构和开发团队管理方式）：一个应用由多个小型独立service组成，service之间通过良好定义设计的API进行通信。每个service由小型、独立的开发团队负责。微服务架构能令应用程序更容易扩展、开发速度更快以及更快交付产品。容器隔离和包装了软件，容器能加快部署速度和减少不必要的资源浪费。  

先说Martin Fowler提出微服务架构应包括：  
    •基于服务的组件化（Componentization via services）  
    •围绕业务能力进行组织（Organized around business capabilities）  
    •产品，而不是项目（Products not projects）  
    •良好设计的endpoint和dump管道（Smart endpoints and dump pipes）  
    •去中心化的管治/统治（Decentralized governance）  
    •去中心化的数据管理（Decentralized data management）  
    •基础设施自动化（Infrastructure automation）  
    •容错设计（Design for failure）  
    •演进式设计（Evolutionary design）  

为了实现以上，通常会采用twelve-factor app pattern（十二因素应用模式方法），这是最佳实践优化的基于云计算的应用程序的指导，这12个因素涵盖四个关键领域：部署，规模/可扩展，可移植性和架构：  
1. 从一个代码库部署到多个环境（Codebase - One codebase tracked in revision control, many deploys）
2. 使用显式的声明隔离依赖，即模块单独运行，并可以显式管理依赖（Dependencies - Explicitly declare and isolate dependencies）
3. 在系统外部存储配置信息（Config - Store configurations in the environment）
4. 把支持性服务看做是资源，支持性服务包括数据库、消息队列、缓冲服务器等（Backing services - Treat backing services as attached resources）
5. 严格的划分编译、构建、发布、运行阶段，每个阶段由工具进行管理（Build, release, run - Strictly separate build and run stages）
6. 应用作为无状态执行（Processes - Execute the app as one or more stateless processes）
7. 经由端口绑定导出服务，优先选择 HTTP API 作为通用的集成框架（Port binding - Export services via port binding）
8. 并发性使用水平扩展实现，对于web就是水平扩展web应用实现（Concurrency - Scale out via the process model）
9. 服务可处置性，任何服务可以随意终止或启动（Disposability - Maximize robustness with fast startup and graceful shutdown）
10. 开发和生产环境保持高度一致，一键式部署（Dev/prod parity - Keep development, staging, and production as similar as possible）
11. 将日志看做是事件流来管理，所有参与的服务均使用该方式处理日志（Logs - Treat logs as event streams）
12. 管理任务作为一次性的过程运行，比如使用脚本管理服务启动和停止（Admin processes - Run admin/management tasks as one-off processes）



### 基于服务的组件化（Componentization via services）
微服务架构中，每个服务被分割出来以专注做好一件事、功能，并保证与其他服务合作组合出性能稳定功能齐全的应用。设计微服务是一个解耦过程、工作。微服务架构允许更换或升级，比如如果一个存储应用中的订单管理模块/服务比其他模块/服务落后或者缓慢，通过微服务架构则可以直接将它换成更高性能，更精简的组件而不用更改、影响其他模块/服务。  
通过模块化，微服务为开发人员提供了设计自由，每个服务都是一个黑盒子即隐藏了该服务的细节复杂性（即一个服务完全不用理会另一个服务的内部、实现细节）。服务之间通过良好定义的API来进行所有通信以防止隐式和隐藏依赖。  
微服务的解藕使得一个服务的开发团队无需等待另一个服务的开发团队完成工作才能开始工作，这大大提高了团队合作、管理的灵活性。任何时候，一个或多个容器镜像（即服务镜像）都应可以随时切换版本而不影响其他容器（服务）的工作、协作（开发时只要做到保留functionality和boundaries就可以实现）。  
容器化是一种操作系统级的虚拟化方法，不用启动整个虚拟机（VM）即可部署和运行分布式应用程序。容器镜像是层级的，其在一个基础镜像上构建功能。开发人员，运营团队和IT领导者应就基础镜像达成一致：合乎要求的安全性和配套工具。这些镜像之后可以作为初始构建块在整个团队、企业中共享。替换或升级这些基础镜像就像更新Dockerfile中的FROM字段一样简单，镜像rebuild通常通过CI/CD管道实现。  
在组件化中，十二因素应用模式方法的这三个因素最为重要：  
    •依赖关系（显式声明和隔离依赖关系） - 依赖关系在容器中是self-contained的而不是与其他服务共享的。  
    •服务可处置性（通过快速启动和平滑关闭来提高系统的稳健性） - 通过容器可以快速从repository中提取代码并在停止运行时快速discarded实现。  
    •并发（通过process model扩展） - 包括task或pods（一个pod由多个容器组成）可以通过自动扩展内存和CPU效率的方式实现。  

每个业务功能以一个独立的服务实现，系统成长的过程中，容器化的服务们会越来越多。而每个服务都应该有自己的集成、部署管道，这样可以提高了敏捷灵活性。因为容器化的服务将会频繁地部署，因此需要引入一个协调层来跟踪哪些容器在哪些主机上运行，慢慢的，你将需要一个可以随时查看容器状态以及剩余可用集群资源等等功能的系统。
容器编排和调度系统允许你通过组装一组协同工作的容器来构建、定义你的应用（这个定义可以看作应用的蓝图），你可以指定各种参数，比如使用哪些容器以及容器绑定哪个repository、应该在容器实例上开放哪些端口给应用、以及应安装的数据卷。
容器管理系统允许你运行和维护指定数量的容器实例、集（他们是同时被实例化、创建的），这些容器通过link或数据卷进行协作（Amazon ECS将这些称为Task，Kubernetes将它们称为Pod。）。Schedulers（调度程序）维持服务所需的一定数量的容器、集。此外，服务基础设施前可以添加一个负载均衡器，这样可以在容器集中分配流量（根据服务）。

### 围绕业务能力进行组织
准确定义微服务的构成非常重要
开发团队达成一致意见。 它的界限是什么？ 是一个应用程序
微服务？ 共享库是微服务吗？
在微服务之前，将围绕系统架构进行组织
技术功能，如用户界面，数据库和服务器端逻辑。
在基于微服务的方法中，作为最佳实践，每个开发团队
拥有服务的生命周期一直到客户。 例如，a
推荐团队可能拥有开发，部署和生产
支持和收集客户反馈。