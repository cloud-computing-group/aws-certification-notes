## A Cloud Guru
  
### 什么是 OpsWorks
* 允许你使用 Puppet 或 Chef 自动化配置你的服务器、VM、实例
* 使用环境已配置、管理好的实例运行 Puppet 或 Chef（即开通实例即已为 Puppet 或 Chef 配备好，你不用劳心去下载相关软件、配置环境）
* 为你的操作系统及应用启用配置管理
* 允许你通过代码自动化配置服务器
* 兼容已有的 Puppet 及 Chef 代码
  
配置管理工具 Puppet 和 Chef 让你很容易保证服务器配置一致性。（可运行在 Linux 及 Windows 操作系统）  
自动化比如还可以执行一些 cronjob 等等。  
  
如果你要用 Puppet 或 Chef 管理 EC2 实例及 on-premises 服务器，就选择 OpsWorks。  
  
现阶段 OpsWorks 可以分为 3 个：  
* AWS OpsWorks for Chef Automate - 自管理 Chef 自动化配置平台。
* AWS OpsWorks for Puppet Enterprise - 自动化 Puppet 自动化配置平台。
* AWS OpsWorks Stacks - 应用与服务管理服务，以前叫 AWS OpsWorks。比如允许应用在 stack 里的部署，使用 Chef Solo 进行配置。  
  
### AWS OpsWorks Stacks
* 管理你的 AWS 或 On-premises 应用
* 设计 layers 执行不同功能，比如负载均衡、数据库、应用服务等等
* 支持 Auto Scaling 和 Scheduled Scaling
* 使用 Chef Solo  
基于云的计算通常涉及各组 AWS 资源，如 EC2 实例和 Amazon Relational Database Service (RDS) 实例。例如，一个 Web 应用程序通常需要应用程序服务器、数据库服务器、负载均衡器以及其他资源。此组实例通常称为堆栈。  
层代表一组服务特定目的 (如提供应用程序服务或承载数据库服务器) 的 EC2 实例。  
  
#### Chef
* OpsWorks Stacks/Chef 是声明式状态引擎  
* 你声明想要发生的，OpsWorks 处理如何执行  
* OpsWorks has resource it can use，例子比如包安装、配置文件更新、服务控制，下面是用例
```ruby
package "httpd" do
    action :install
end

package "httpd" do
    action [:enable, :start]
    supports :restart => :true
end

template "var/www/html/index.html" do
    source "index.html.erb"
    owner "apache"
    group "apache"
    mode "0644"
    notifies :restart, "service[httpd]"
end
```
* Recipes 告诉 OpsWorks Stacks/Chef 你想要的最终是什么即可（如上，不需要你告诉它怎么做只需要告诉它最后要什么）
  
尽管类似，AWS OpsWorks 更像夹杂在 AWS Elastic Beanstalk 和 AWS CloudFormation 中间的一层服务。  
  
### Lab
步骤：  
1. 进入 AWS OpsWorks 控制台，选择 OpsWorks Stacks
2. 创建、添加 stack（预安装 Chef 环境的 Linux 或 Windows 实例组的 stack），配置 VPC 网络、region、操作系统、SSH 密钥、EBS 存储、IAM role、agent 版本等等
3. 创建、添加 layer（选项卡有 OpsWorks、ECS、RDS），选择 OpsWorks 选项卡后 layer 类型比如选 Static Web Server 以及 ELB
4. 点击 Instances 选项卡 -> Static Web Server -> 增添 EC2 实例（以及相关配置）-> start 实例
5. 点击 Apps 选项卡，完成配置（比如程序代码仓库地址，选择数据源比如数据库或没有），然后点击部署（实例那里选择上面的 Static Web Server），完成后可检查日志
6. 浏览器访问相关实例或负载均衡（ELB）的 IP 地址，可以看到代码仓库所写的静态网页
7. 其他选项卡还有监控、附着资源、权限、标签等等，layer 选项卡的 layer 类型的页面（比如 Static Web Server）的 Recipes 选项卡可见且可以链接到 AWS 的 GitHub 代码仓库 opsworks-cookbooks 的 Recipes 示例代码同时你也可以自定义你的 Chef Recipes（也是通过链接比如你自己的 GitHub 的代码仓库）
  
