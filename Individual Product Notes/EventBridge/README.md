Amazon EventBridge 是一种无服务器事件总线服务，您可以使用它将应用程序与来自各种来源的数据（如 AWS 服务 Event 或第三方服务如 Salesforce 的 Event，这些标准 Event 都已内置，你也可以自定义 Event）连接起来。EventBridge 可以从应用程序、软件即服务 (SaaS) 应用程序和应用程序传输实时数据流，AWS向目标提供的服务，例如 AWS Lambda 函数、使用 API 目标的 HTTP 调用终端节点或其他中的事件总线 AWS 账户。  
  
EventBridge 以前被称为 Amazon CloudWatch Events。  
  
EventBridge 收到 Event（事件），是环境变化的指标，并应用 Rule（规则）将事件路由到 target（比如 CloudWatch Logs Group、Lambda、SNS [等等服务](https://docs.aws.amazon.com/zh_cn/eventbridge/latest/userguide/eb-targets.html)）。规则根据事件的结构将事件与目标匹配，称为事件模式，或按计划进行。例如，当 Amazon EC2 实例从挂起变为正在运行时，可以拥有将事件发送到 Lambda 函数的规则。  
