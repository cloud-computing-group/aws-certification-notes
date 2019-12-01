Chef 是一款自动化服务器配置管理工具，可以对所管理的对象实行自动化配置，如系统管理，安装软件等。Chef 由三大组件组成：Chef Server、Chef Workstation 和 Chef Node。  
Chef Server 是核心服务器，维护了一套配置脚本（Cookbook），与每个被管节点（Chef Node）交互并给出配置指令。  
Chef Workstation 提供了我们与 Chef Server 交互的接口：我们在 Workstation 上创建定义 Cookbook，并将 Cookbook 上传到 Chef Server 上以保证被管机器能从 Chef Server 上取得最新的配置指令。  
Chef Node 是安装了 chef-client 并注册了的被管理节点，可以是物理机或者虚拟机或者其他对象。Chef Node 每次运行 chef-client 时都会从 Chef Server 端取得最新的配置指令（Cookbook）并按照指令配置自己。  
一套 Chef 环境包含一个 Chef Server，至少一个 Chef Workstation，以及一到多个 Chef Node。  