## A Coud Guru
  
1. Building Blocks (it is a language that gives you building blocks to describe the infrastructure you want to provision in AWS)
2. Text files (Containing that description. Formatting in JSON or YAML. You can version control it and track changes like any other piece of code.)
3. Free (You can build your entire infrastructure with CloudFormation. You can version it.)
  
Terms:  
1. Stack (A collection of AWS resources that you manage as a single unit. The stack is created when you give the CloudFormation service your template.)
2. Template (The document that describes how to act and what to create. Literally the text that you write that CloudFormation uses to provision infrastructure. A template can be used to both create and update a stack.)
3. Stack Policy (IAM style policy statement which governs what can be changed and who can change it.)
  
### CloudFormation 简介
* CloudFormation 服务可以让你通过代码来管理、配置、开通你的 AWS 基础设施服务。
* 资源通过 CloudFormation 代码模版来定义、声明。
* CloudFormation 会解释该代码模版从而调用相应的 AWS API 来创建、更新被定义、声明的资源。
* 该模版支持 YAML 或 JSON 格式。
  
### CloudFormation 优点
* 基础设施、服务、资源保证了更一致性地开通、创建、更新，从而减少了（基于人的手动工作的）错误。
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
* 使用 YAML 或 JSON 模版描述基础设施的服务开通或更新的结束状态。
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
* CloudFormation 让你可以通过代码（YAML 或 JSON 格式）来管理、配置、服务开通 AWS 的基础设施。
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