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