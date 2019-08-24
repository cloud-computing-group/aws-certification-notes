## A Cloud Guru
  
### 什么是 Inspector
自动化地访问你的应用以检测漏洞（比如 EC2 实例网络中出现非安排的访问、实例里的漏洞），并生成安全发现报告。  
主要保护 EC2 实例。收费服务。  
  
好处：  
* 锁定安全问题
* API-driven（可在实例中安装可选 Agent 以获取更好的检查）
* 减少风险，防范于未然
* 应用专业知识（专家式的持续为你寻找可能的安全漏洞）
* 强制标准 - 定义并制定属于你的应用的安全标准  
  
### Lab
评估设置包括：网络评估（Agent 安装是可选的）、主机评估（要求安装 Agent）。  
评估可以单次运行也可以每周运行一次。  
控制台选项卡包括评估目标、评估模版、评估运行及其状态与结果（比如有 ？个发现，其中包括详细描述比如 VPC 网络里的某个端口外部可访问，以及其紧急程度）。  
评估结束后可以生成正式的 PDF/HTML 报告。  
评估报告的数据也可以通过 Inspector 的 API 获取。  
  
### 如何工作
1. 创建“评估目标”（通过实例的 Tag 定位目标，在此之前需先开通启动一个实例）
2. 安装 Inspector Agent 到 EC2 实例（可以 SSH 实例然后通过 wget、curl 这类工具安装，也可以通过 Systems Manager 运行命令以安装）
3. 创建“评估模版”（主要是定义 Rules packages - 可选比如安全最佳实践、运行性能分析、常见漏洞与泄漏、CIS操作系统安全配置基准等等，以及定义持续时间 - 越长可能 Rule 执行得越完善）（你也可以使用 Master Template，该模版会一次检查多个 Rules，并设置 SNS topic 等等）
4. 执行“评估运行”
5. 针对“Rule”回顾“发现”（全面检查评估目标的网络、文件系统、进程行为，然后比较所见情况与安全 Rules，从而得出发现的问题）  
Inspector 在 shared responsibility model 下不会要求你负责。  
  
### Inspector Rule 的 Severity level
* High
* Medium
* Low
* Informational  
  
