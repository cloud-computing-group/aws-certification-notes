## A Coud Guru
  
1. Building Blocks (it is a language that gives you building blocks to describe the infrastructure you want to provision in AWS)
2. Text files (Containing that description. Formatting in JSON or YAML. You can version control it and track changes like any other piece of code.)
3. Free (You can build your entire infrastructure with CloudFormation. You can version it.)
  
Terms:  
1. Stack (A collection of AWS resources that you manage as a single unit. The stack is created when you give the CloudFormation service your template.)
2. Template (The document that describes how to act and what to create. Literally the text that you write that CloudFormation uses to provision infrastructure. A template can be used to both create and update a stack.)
3. Stack Policy (IAM style policy statement which governs what can be changed and who can change it.)
  
### CloudFormation 简介
* CloudFormation 服务可以让你通过代码来管理、配置、开通你的 AWS 基础架构（或者说基础设施）服务。
* 资源通过 CloudFormation 代码模版来定义、声明。
* CloudFormation 会解释该代码模版从而调用相应的 AWS API 来创建、更新被定义、声明的资源。
* 该模版支持 YAML 或 JSON 格式。
  
### CloudFormation 优点
* 基础架构、服务、资源保证了更一致性地开通、创建、更新，从而减少了（基于人的手动工作的）错误。
* 相比手动配置以上设施、服务、资源，花费更少的时间、精力。
* 可以进行版本控制（比如 git）以及模版代码能方便他人评审检错。
* 免费使用（当然被创建的资源还是要按自己原来的价格收费）。
* 可以用来管理更新以及依赖（比如资源、服务以正确的顺序创建、更新）。
* 可以用来支持回滚或方便删除整个栈（一体化删除栈内所有资源、服务，省的一个个麻烦地删或遗漏删除导致继续付费）。
  
### CloudFormation 使用场景
* 需创建重复的模式化的环境，比如作为网站托管生意要帮不同的客户重复创建同样的 Wordpress 博客及其数据库环境与各种资源、设定。
* 可以为 CI/CD 环境运行自动化测试：创建一个专用的全新的环境，放入代码及程序，运行测试，产生结果，删除整个测试环境（全程无人工输入干扰）。
* 只需定义一次环境，就直接部署到 AWS 云平台的任何 Region 而无需每次为每个 Region 重复做相同的定义、配置、动作（模版里的 Mappings 允许根据 Region 的不同设定某些值与设定不同）。
注意：CloudFormation 模版应该很好地设计以适用于多个 Region 且规模至 1100 或 1000 个应用的适用场景（使用尽可能少的变量以减少可能的冲突）。  
  
### CloudFormation 模版
* 使用 YAML 或 JSON 模版描述基础架构的服务开通或更新的结束状态。
* 创建或更新完模版后，通过上传至 S3 bucket 从而可以将其上传给 CouldFormation。
* CloudFormation 读取模版（从相关 S3 bucket）并为你调用相关 AWS API 调动 AWS 资源。
* 其所有的被调动、更改的资源被总称为一个 `Stack` 或 `CloudFormation Stack`。
  
### CloudFormation 模版结构（YAML）
例子（更多信息可参考：https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html）：  
```yaml
AWSTemplateFormatVersion: "2010-09-09" # 此处指的是 CloudFormation 支持的模版格式版本，与开发者的代码版本控制无关
Description: "Template to create an EC2 Instance" 
Metadata: 
  Instances:
    Description: "Web Server Instance"

Parameters: # input values, allow the passing of variables into the template via the UI、CLI or API, you need to provide when launch this stack
  EnvType:
    Type: String
    AllowedValues: 
      - prod
      - test
    Description: "Environment Type."
# InstanceTypeParameter: 
#   Type: String
#   Default: t2.micro
#   AllowedValues: 
#     - t2.micro
#     - m1.small
#     - m1.large
#   Description: Enter t2.micro, m1.small, or m1.large. Default is t2.micro.

Conditions:
  CreateProdResources: !Equals [ !Ref EnvType, prod ] # in this case, based on above parameters

Mappings: # e.g. set values based on a region
  RegionMap: 
    eu-west-1: 
      "ami": "ami-Obdb1d6c15a40392c" # 要根据 Region 配置不同的 AMI ID，若想知道某个 Region 支持的 AMI ID 是多少，可以通过切换 Region，点击 EC2 控制台的 Launch Instance，然后可选的 AMI 列表里就可以看到、复制该 Region 相应 AMI 的 ID 了

Transform: # include snippets of code outside the main template, for example: severless lambda function's code or some other code want to be reused/consistent like create table info for DynamoDB (https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/CHAP_TemplateQuickRef.html), these snippets of code can be stored in S3 bucket
  Name: 'AWS::Include'
  Parameters:
    Location: 's3://MyAmazonS3BucketName/MyFileName.yaml'

Resources: # the AWS resources you are deploying
  MyEC2Instance:
    Type: "AWS::EC2::Instance"
    Properties:
      InstanceType: t2.micro
      ImageId: "ami-Obdb1d6c15a40392c"

Outputs: # 除了 EC2 实例，也可以 output 其他 CloudFormation Stack
  InstanceID:
    Description: The Instance ID
    Value: !Ref MyEC2Instance # Output 上面 Resources 的配置的最终被服务开通的实例的 ID
```
* `Resources` 项是整个 CloudFormation 模版里的唯一一个必填项。
* `Transform` 项用来引用 CloudFormation 模版之外的代码，这些可复用代码将存入 S3 中，比如：Lambda 的代码或其 template snippets，又或者可复用的 CloudFormation 模版代码片段。
  
### Exam Tips
* CloudFormation 让你可以通过代码（YAML 或 JSON 格式）来管理、配置、服务开通 AWS 的基础架构。
* CloudFormation 模版里各项的作用：
    * Parameters - 引入自定义的值（还可以通过 UI、CLI 或 API 传递这些值给模版）。
    * Conditions - 比如：根据环境开通（相应）服务。
    * Resources - 必填，要创建、声明的 AWS 资源。
    * Mappings - 创建自定义的映射如 Region : AMI（映射不同的 AMI 到不同的 Region，这样可以告诉 AWS 当在某一 Region 工作或运行服务时使用该 Region 映射的 AMI），通常是一个键值哈希。
    * Transform - 引用 S3 里存的代码。
    * Outputs - 该模版执行后的结果。
  
### CloudFormation Lab
创建过程：  
1. 打开 CloudFormation 控制台
2. 点击 `创建新的 stack`
3. 选择创建新的 CloudFormation 模版、AWS 样本模版或复用已有的模版或上传本地的模版文件
4. 指定、填写 stack 名，传递/选择 Parameters（即上面的 Parameters 项）（如果是设定了 AWS 的资源 Type 如 KeyPair，则可以得到一个下拉列表并选择，列表里的选项都是你的 AWS 平台在该 Region 里已有的数据、资源 -- 在这里就比如已有的 KeyPair）
5. 更多选项，包括高级设置（比如：一旦新模版部署开通失败则自动回滚）
6. 再次 review 所有设置，没问题则点击 `创建`，然后需要数分钟等待 stack 部署完成（完成后可点击 `my stack`，可以看到所有的与该 stack 相关的事件，在此处也可以再次检查模版的代码、传入的 Parameters 和 Outputs）
  
删除过程：  
前往 CloudFormation 控制台 -> Stack 列表页面 -> 勾选 stack -> Actions 按钮 -> 删除 stack -> 确定删除 -> 然后等候删除完成即可  
需要注意的是，在 stack 完成被删除之前，该 stack 相关的 S3 bucket 模版无法删除（因为依赖关系），而 stack 删除之后，该模版也不会自动删除，不过你可以自行手动删除。  
  
除了通过模版，你还可以在 AWS 上以可视化拖拽的形式创建、更新 stack。  
开通不同的单个 AWS 服务、资源的 stack 的 CloudFormation 模版案例：https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/CHAP_TemplateQuickRef.html  
  
### AWS CloudFormation (内置函数) Intrinsic Functions
AWS CloudFormation 提供这些函数以协助直到在运行时才赋值给模版的属性、参数、变量，从而使得模版更灵活。  
一些内置函数例子：  
* Ref（返回指定的 parameter 或 resource 的数值，在 JSON 中唯一不用 `Fn::` 作为前缀的函数，但在 YAML 里和其他内置函数一样要加前缀 `!` 或 `Fn::`）（JSON 用例：{"Ref" : "logicalName"}）
* FindInMap（在映射中根据键查找相应的值）
* Base64（对输入的字符串进行 base64 加密，比如给 EC2 的 UserData 传递数据时就需要此加密）（JSON 用例：{"Fn::Base64" : valueToEncode}）
* Cidr（获取一组 CIDR 网络地址，基于传入的 countValue -- 其范围从 1 至 256）（JSON 用例：{"Fn::Cidr" : [ipBlock, count, cidrBits]}）
* GetAtt（即 Get Attributes，返回模版里某个 resource 的 attributes，比如某个负载均衡的 DNS 名）（JSON 用例：{"Fn::GetAtt" : ["logicalNameOfResource", "attributeName"]}）
* GetAZs（返回指定 Region 的 Avaliability Zones 列表、数组）（JSON 用例：{"Fn::GetAZs" : "region"}）
* ImportValue（返回其他 stack 输出的 Output 值，一般用于创建跨 stack 的引用，比如创建了一组数据库并输出它们的 DNS 名然后接着你的 EC2 可以获取这些数据给另一个 stack 比如 Wordpress 使用）（JSON 用例：{"Fn::ImportValue" : shareValueToImport}）
* Join（将一组值附加、append 给一个值，以指定分隔符分隔，比如给一组机器 ID 的前缀加上一个环境值如 prod 或 dev）（JSON 用例：{"Fn::Join" : ["delimiter", [comma-delimited list of values]]}）
* Select（根据索引值 index 从一组对象中返回相应映射的对象）（JSON 用例：{"Fn::Select" : [index, listOfObjects]}）
* Split（与 Join 相反，可以把一个字符串分解为多个字符串、元素、值，然后从而可以使用 Select 选择其中一个元素）（JSON 用例：{"Fn::Split" : ["delimiter", "source string"]}）
* Sub（用指定数值替代一个字符串的输入变量，比如一个字符串需要 VPC name，可以用 Sub 在 VPC 创建好后的 name 加入）（JSON 用例：{"Fn::Sub" : [String, {Var1Name: Var1Value, Var2Name: Var2Value}]}）
* Transform（在 stack 的模版里，指定一个 macro 去执行自定义的处理多个部分，比如可以替你在模版里进行 Find and Replace 操作）（JSON 用例：{"Fn::Transform" : {"Name" : macro name, "Parameters" : {key : value, ...}}}）  
  
还有以下内置的条件函数（可以让你基于条件创建、更新 stack 资源，并通过你在创建、更新 stack 时声明的 input parameters 来判断）：  
* Fn::And
* Fn::Equals
* Fn::If
* Fn::Not
* Fn::Or
条件函数用法可参考：https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/conditions-sample-templates.html  
  
  
  
### AWS CloudFormation Wait Conditions
  
#### DependsOn
用于控制 CloudFormation 里的资源的创建顺序  
```yaml
Resources:
  MyEC2Instance:
    Type: AWS::EC2::Instance
    Properties: 
      ImageId: "ami-Obdb1d6c15a40392c"
    DependsOn: GatewayToInternet

GatewayToInternet:
  Type: AWS::EC2::VPCGatewayAttachment
  Properties: 
    VpcId: 
      Ref: VPC
    InternetGatewayId:
      Ref: InternetGateway
```
以上 EC2 会等待 CloudFormation 返回报告依赖已就绪（大部分时候这很安全，但是也有些时候依赖就绪不代表依赖内部所有配置设置都完成了，因此接下来引入 creation policies）  
  
#### Creation Policies
指定 CloudFormation 收到指定（数量）的成功信号或等待到了指定 timeout 时间前不能让某资源状态达到`创建完成`。  
```yaml
CreationPolicy:
  ResourceSignal:
    Count: '3'
    Timeout: PT15M
```
Here is UserData attached to your EC2 instance（如上所写，需要以下 cfn-signal 命令运行三次）:  
```bash
yum update -y aws-cfn-bootstrap 
/opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource AutoScalingGroup --region ${AWS::Region}
```
以上总结就是需要等待 3 个 EC2 实例 setup 完成（发送 3 次完成信号），CloudFormation 才继续往下着手创建其他依赖于它们的资源、stack。
  
#### Wait Conditions & Handlers
* 用来让你协调其他 stack 的配置动作与某个 stack 资源创建，这些配置动作与该 stack 无直接关系
* 允许你跟踪配置过程的状态
* Wait Condition Handles 是可以生成安全签名（signed）URL 的无属性资源，用于通信
* Wait Condition 有以下 4 个组件：
    * DependsOn
    * 上面提及的 Handle
    * 响应 timeout
    * count（前面提及的成功信号指定数），默认是 1
  
#### Wait Conditions & Handlers 用例
```yaml
# Wait Condition Handle，会有一个预先签名的 URL 被创建
WaitHandle:
  Type: AWS::CloudFormation::WaitConditionHandle

# Wait Condition
WaitCondition:
  Type: AWS::CloudFormation::WaitCondition
  DependsOn: "WebServerGroup"
  Properties: 
    Handle: 
      Ref: "WaitHandle"
    Timeout: "300"
    Count:
      Ref: "WebServerCapacity"

# Resource
WebServerGroup:
  Type: AWS::AutoScaling::AutoScalingGroup
  Properties:
  LaunchConfigurationName:
    Ref: "LaunchConfig"
  MinSize: "1"
  MaxSize: "5"
  DesiredCapacity:
    Ref: "WebServerCapacity"
  LoadBalancerNames:
    -
      Ref: "ElasticLoadBalancer"
```
  
#### Wait Conditions & Handlers 与 Creation Policies 对比
* 为什么 Wait Conditions & Handlers 与 Creation Policies 不同
* 有了 Conditions 你可以实现更复杂的服务、资源开通顺序，Wait Conditions 可以依赖于许多资源，也有许多资源可以依赖于它
* 你可以对那些使用 WaitConditions（带有 DependsOn 的）的东西的顺序造成影响
* 额外的数据可以通过 Wait Conditions Handlers 创建的签名 URL 传出、返回，然后可以在模版内被访问到
  
### 什么是 nested（嵌套）stack
比如 stack 包含一组资源（如 S3 bucket、EC2 实例等等）。有了嵌套，定义好的一个 stack 也可以作为一个资源，嵌套 stack 本身可以再嵌套 stack（多重嵌套）。  
好处：  
* 可以把一个巨大复杂的基础架构定义、声明、结构分解为多个模版而不是一个模版。
* CloudFormation 的单个 stack 有限制：200 个资源、60 个 outputs 和 60 个 parameters，通过嵌套你就可以绕过这些限制。
* 这可以使得基础架构即代码 (IaC)更有效和复用性更好。
  
用例：  
```yaml
Type: AWS::CloudFormation::Stack
Properties: 
  NotificationARNs: # The Simple Notification Service (SNS) topic ARNs to publish stack related events
    - String
  Parameters: # The set value pairs that represent the parameters passed to CloudFormation when this nested stack is created. AWS CloudFormation Stack Parameters
    Key : Value
  Tags: # Key-value pairs to associate with this stack. AWS CloudFormation also propagates these tags to the resources created in the stack.
    - Resource Tag
  TemplateURL: String # Location of file containing the template body. The URL must point to a template (max size: 460,800 bytes) that is located in an Amazon S3 bucket.
  TimeoutInMinutes: Integer
```
  
### 资源删除 policies
* 与 CloudFprmation 模版里每个资源相关的
* 一种决定资源在 stack 被删除后的去留处理的控制方式
* policy 选项包括：
    * Delete（默认，即 stack 被删除则相关资源自动都被删除）
    * Retain（即 stack 删除后资源仍被保留甚至运行，除非你在 AWS 平台上手动删除它们）
    * Snapshot（比如 EC2、RDS 实例、Redshift 集群等等，备份资源及其数据的快照然后删除资源实体，用例比如不想有服务运行的费用同时可以按需保留之前的服务如数据库里的数据）  
用例：  
```yaml
myS3Bucket:
  Type: "AWS::S3::Bucket"
  DeletionPolicy: Retain
```
  
### Stack 更新
当更新 stack 时，正在发生：
* 该 stack policy 检查（该操作者是否有权限更新）
* 更新 orchestrated（基础架构的编排）  
Stack policy 例子（允许更新任何设施除了某个资源的数据库）：  
```json
{
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : "Update:*",
      "Principal": "*",
      "Resource" : "*"
    },
    {
      "Effect" : "Deny",
      "Action" : "Update:*",
      "Principal": "*",
      "Resource" : "LogicalResourceId/ProductionDatabase"
    }
  ]
}
```
更多：  
* 没有任何 policy，则默认允许更新所有资源
* 一旦 policy 被 apply 就不能删除
* 一旦 policy 被 apply 则默认所有对象不允许更新（如果想让更新进行，则要明确指定某个对象比如通过ID指定）  
```json
{
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : "Update:*",
      "Principal": "*",
      "Resource" : "*"
    },
  ]
}
```
  
### 资源 Impacts
* 更新过程中，实际发生的具体更新是基于资源或是其属性，有 4 种可能的 impacts：
    * 服务运行完全不打断（Interruption）（比如 DynamoDB Table 的 ProvisionedThroughput 更新）
    * 部分服务运行打断（如某些服务停止、重启，比如更新 EC2 实例的 Instance Type）
    * 替换（服务整个替换掉即删除后再重新创建，比如更新 EC2 实例的 Availability Zone）
    * 删除（服务整个删除）  
AWS CloudFormation 的官方文档的每个服务的属性都会有详细介绍其 Update Type 和 Impacts。  
  
### Custom Resource（自定义资源）
Custom Resource 让你可以在模版里写入 custom provisioning 逻辑，从而扩展 CloudFormation 适用于 AWS 之外的资源（如外部 API）又或者是尚未获得 CloudFormation 支持的 AWS 资源。  
#### How it works
1. 模版开发者 - 创建自定义资源类型的模版，同时定义了服务的 token 以及允许输入参数、数据。
2. 自定义资源 provider - 拥有该自定义资源并知道如何处理、响应来自 CloudFormation 的请求，且必须提供给开发者其服务的 token。
3. AWS CloudFormation - 发送请求（以及 token）至资源 provider，等待处理、响应完成后再进行 stack 的下一步操作。  
用例：  
Information：  
* 使用一个 Lambda function
* Lambda 获取最新的 AMI ID 以创建一个 EC2 实例
* 创建了一个 stack，包括：
    * 该 Lambda function
    * 一个 IAM role
    * 一个自定义资源
    * 一个 EC2 资源  
```yaml
AMIInfoFunction: 
  Type: "AWS::Lambda::Function"
  Properties: 
  Code:
    S3Bucket: !Ref S3Bucket
    S3Key: !Ref Key
  FunctionName: String
  Handler: !Sub "${ModuleName}.handler"
  Runtime: nodejs8.10
  Role: !GetAtt LambdaExecutionRule.Arn
  Timeout: 30
```
```yaml
LambdaExecutionRole:
  Type: AWS::IAM::Role
  Properties:
    AssumeRolePolicyDocument:
      Version: '2012-10-17'
      Statement:
      - Effect: Allow
        Principal:
          Service:
          - lambda.amazonaws.com
        Action:
        - sts:AssumeRole
    Path: "/"
    Policies:
    - PolicyName: root
      PolicyDocument:
        Version: '2012-10-17'
        Statement:
        - Effect: Allow
          Action:
          - logs:*
          Resource: arn:aws:logs:*:*:*
```
```yaml
AMIInfo:
  Type: Custom::AMIInfo
  Properties:
    ServiceToken: !GetAtt AMIInfoFunction.Arn
    Region: !Ref "AWS::Region"
    Architecture:
      Fn::FindInMap:
      - AWSInstanceType2Arch
      - !Ref InstanceType
      - Arch
```
```yaml
SampleInstance:
  Type: AWS::EC2:Intance
  Properties:
    InstanceType: !Ref IntanceType
    ImageId: !FetAtt AMIInfo.Id
```