## A Cloud Guru
  
### Tags & Resource Group
什么是 Tags：  
* 附着在 AWS 资源上的键值对（比如给 EC2 实例一个别名）
* 元数据
* Tags（标签）有些时候可以继承
    * Auto Scaling、CloudFormation、Elastic Beanstalk 可以创建其他资源（即被服务开通的资源可以继承开通它们的比如 CloudFormation、Elastic Beanstalk 的标签）  
  
什么是资源组（Resource Group）：  
通过一个或多个标签，资源组可以让你更容易地对资源进行分组。  
资源组包括以下信息：  
* Region
* 名字
* Health Check  
特定信息：  
* 比如 EC2 - 公共 & 私有 IP 地址
* 比如 ELB - 端口配置
* 比如 RDS - 数据库引擎等等  
资源组有 2 种：  
* Classic Resource Groups - Global 的
* AWS Systems Manager - Region based 的  
创建 Classic 资源组时只需在 AWS 控制台右上角点击 Resource Groups -> 下拉列表点击 Create Classic Resource Groups 即可。  
创建 AWS Systems Manager 资源组则只需在 AWS 控制台右上角点击 Resource Groups -> 下拉列表点击 Create a Group 即可（其实是重定向到 AWS Systems Manager 控制台页面）。  
  
