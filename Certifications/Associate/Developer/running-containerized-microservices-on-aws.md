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
    •基于服务的组件化  
    •围绕业务能力进行组织  
    •产品，而不是项目  
    •良好设计的endpoint和dump管道  
    •去中心化的管治/统治  
    •去中心化的数据管理  
    •基础设施自动化  
    •容错设计  
    •演进式设计  

为了实现以上，通常会采用twelve-factor app pattern（十二因素应用模式方法），这是最佳实践优化的基于云计算的应用程序的指导，这12个因素涵盖四个关键领域：部署，规模/可扩展，可移植性和架构：  
1. Codebase - One codebase tracked in revision control, many deploys
2. Dependencies - Explicitly declare and isolate dependencies
3. Config - Store configurations in the environment
4. Backing services - Treat backing services as attached resources
5. Build, release, run - Strictly separate build and run stages
6. Processes - Execute the app as one or more stateless processes
7. Port binding - Export services via port binding
8. Concurrency - Scale out via the process model
9. Disposability - Maximize robustness with fast startup and graceful shutdown
10. Dev/prod parity - Keep development, staging, and production as similar as possible
11. Logs - Treat logs as event streams
12. Admin processes - Run admin/management tasks as one-off processes
