## A Cloud Guru
  
Step function 是基于 Lambda function 的一项 AWS 服务。  
* 一个让你编排你的 Lambda functions 的服务
* 一个可靠的一步步执行 functions 来按你想要的顺序、逻辑来驱动你的应用的服务，还可以方便实现一些如异步 Lambda function 的逻辑
* 提供你一个你的应用组件的可视图  
  
### Step Function
Step Function 提供了一个图形控制台，可以让开发者可视化、测试他们的 serverless 应用，可以管理并可视化应用的每一个 component 以组成一系列步骤（step）。这样简化了创建、运行多步骤的应用。Step function 自动地触发、跟踪每个步骤，若步骤报错则会重试，所以保证应用会如期望那样按步骤顺序进行。Step function 会 log 每个步骤的 state，所以若有任何错误发生时，可以很容易诊断和 debug。  
  
### How it works?
使用 JSON-based 的 Amazon States Language 来编写、定义开发者的工作流（workflow）的步骤，写好后 Step Function 的图形化控制台会自动画出步骤图。在控制台里还可以测试、模拟这些步骤。Step function 运作并 scales 开发者的应用，underlying compute 以应对 increasing demand 保证应用运行稳定。  
创建一个新的 Step function resource 后，会触发一个 CloudFormation template（过程需等待数分钟），然后就可以选择创建一个新的 execution（就可以看到一个实时的 Visual workflow，观察实时进行到哪一步，也可以去 AWS Batch 服务的控制台去观察）。（每一个步骤也可以 log 到 CloudWatch）  
  
要删除掉已有的 Step Function，可以在 CloudFormation 控制台，删除掉相关的 CloudFormation template 即可。
  
### Tips
* Great way to visualize your serverless application.
* Step Functions automatically triggers and tracks each step.
* Step Function logs the state of each step so if something goes wrong you can track what went wrong and where.
  
### 更多用例
https://docs.aws.amazon.com/zh_cn/step-functions/latest/dg/create-sample-projects.html  