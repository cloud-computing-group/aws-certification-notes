## A Cloud Guru
  
### 什么是 EC2
EC2 是 AWS 提供的可以调整大小的 IaaS 虚拟机服务。  
  
### EC2 Pricing Models - Refresher
* On Demand
    * 低成本及灵活的使用 EC2 实例，且没有预付费及长时间的合同
    * 适用于应用是短时间的、负载不均的、负载不可预测且不能受性能影响或打断的
    * 适用于应用第一次在 EC2 上开发测试的场景
* Reserved（RI - Reserved Instance）
    * 应用状态稳定且负载使用可预期
    * 应用要求预留的算力、存储等 capacity
    * 使用者可通过预付款以获得更多折扣
        * Standard RI's，比如 3 年签约则对比 On Demand 最多有 75% 折扣（也可以 pay as you go，但就没有或很少折扣了）
        * Convertible RI's，对比 On Demand 最多有 54% 折扣，符合条件情况下可更新 RI 的 attributes
        * Scheduled RI's，允许按天、周、月地持续地周期性地匹配你的 capacity reservation
* Spot
    * 适用于应用有灵活的开始与结束时间
    * 适用于应用只可行于低成本
    * 用户、开发者紧急需要大量算力
* Dedicated Hosts
    * 专用的物理硬件设备，适用于不允许多租户虚拟化的常规地要求
    * 适用于不支持安装在多租户共享或云部署的 license（比如甲骨文数据库的 license）
    * 可以通过 On Demand 购买
    * 可以通过 Reserved 购买  
  
### EC2 Types - EBS vs Instance Store
当 EC2 首次启动时，所有 AMI 都是来源于 Amazon 的 Instance Store 的。Instance store 又被称为 ephemeral store，意味着是临时、短暂、非长期的。  
稍后，当 AWS 启动 EBS，用户可以用它存放长期数据。  
  
一个混淆：  
Instance store volume 和 EBS volume 是不同的。
首先有 2 种 volume：1. root (device) volume - 安装操作系统的地方；2. additional volume - 这可以是你的 D、E、F 盘或 /dev/sbd、/dev/sdc、/dev/sdd 等等。  
root device volume 可以是 EBS volume 或 Instance store volume。  
Instance store root device volume 最大容量是 10 GB。  
EBS root device volume 可以是最大到 1 或 2 TB（根据操作系统的需要）。  
  
#### 终止（terminate）一个实例 - EBS
EC2 实例可以被终止:  
* EBS root device volumes 默认会在 EC2 实例被终止时终止，你可以停止这个默认行为，通过在创建实例时 uncheck 选项 "Delete on Termination"（控制台或 CLI）
* 但其他附着此实例的 EBS volumes 不会因 EC2 实例被终止而终止  
  
* 默认情况，如果实例被终止，则 Instance store（无论 root 或其他的）都会被终止
* EBS 支撑的实例可以被 stop 但 Instance store 的实例不能被 stop，只能 reboot 或终止  
  
Instance store 里的数据在 reboot 时不会消失，但在以下情况下会消失：  
* 底层硬盘失效、出错
* stopping 一个 EBS-backed（EBS 支撑）的实例
* 终止实例  
  
所以不要把长期数据存放在 instance store 里，而是通过备份机制备份在多个实例上、存在 S3 上或使用 EBS Volume。  
  
### Lab
实例和附着其的 EBS volume 都必须在同一个 AZ。  
可以实时更新 EBS 属性，比如从 gp2 升级到 io1（但 standard 不能向上升级因为是旧的），又或提升容量，更新过程不会有 down time。  
想把 EBS volume 复制到其他 AZ 的话只需要先创建一个快照，然后在基于快照在另一个 AZ 创建新的 EBS volume 即可，快照本身也可以被复制到其他 AZ 并用于制作 AMI（image）。  
  
### Volumes & Snapshots
* volume 在 EBS 里
    * 虚拟硬盘
* snapshot 实际存在 S3 上
* snapshot 是 volume 某一时间点上的复制、备份
* snapshot 是增长地保存 - 只保存块更新的那部分（基于上一次在 S3 上的备份）
    * 因此如果是第一个 snapshot，备份耗时会多一些  
  
### Snapshots of Root Device Volumes
* 为 EBS volume 创建一个用于 root device 的快照前，你应先 stop 实例再给它创建快照
* 若非用于 root device 你可以在实例运行时创建快照
* 你可以从快照或 Image 中创建 AMI
* 若要把 EBS volume 迁移到其他 AZ，先为它创建一个快照或 Image，然后将其复制到其他 AZ  
  
### Volumes vs Snapshots - Security
* 快照若是基于加密了的 volume 的，则快照也自动加密
* volume 若是来自加密的快照，则 volume 也自动加密
* 你可以共享快照，但是它们必须是非加密的
    * 快照可以共享给其他 AWS 账号，也可以设置为 public 的  
  
### AMI
AMI（Amazon Machine Image）提供了所有启动实例所需的信息：  
* root volume 的模版，比如操作系统、应用程序
* 服务开通权限 - 定义哪个 AWS 账号可以使用此 AMI 并开通实例
* block device 映射到指定的 EBS volumes，使其在启动时附着在实例上  
  
* AWS 提供了一系列默认、基础 AMI，比如 Linux 分支、Windows 等
* 你可以创建自定义的 AMI，步骤如下：
    1. 基于基础 AMI 启动一个实例
    2. 连接你的实例（比如 SSH、API、CLI、控制台等等），自定义该实例（比如安装应用或复制迁移数据过来）
    3. 基于此实例创建一个 Image
    4. 该 AMI 必须先注册才能用于日后以启动实例（如果通过控制台进行这些步骤则无需注册因为已自动执行，使用 API、CLI 的话则需要注册）
* AMI 注册是基于 region 的
    * 即如果你想在 region 1 使用 region 2 的 AMI 来启动一个实例，你需要先把该 AMI 复制到 region 1 才能启动实例
    * API、CLI 默认情况下创建完 AMI 后没有绑定该 AMI 到任何 region，因此你无法在任何 region 里找到 AMI 并使用，因此需要注册它到你指定 region  
  
### 共享 AMI
除了上面提及过的 AMI 共享方式，你甚至可以销售你的 AMI 给其他 AWS 用户，默认情况下新建的 AMI 是私有的。  
共享此 AMI 的账号仍有对此 AMI 的控制权，也会因存储该 AMI 而被收取一些费用（AMI 实际存储在 S3 上）。  
AMI 拥有者需要给予另一个 AWS 账号权限，那个账号才能从 EBS 快照或 S3 上复制该 AMI，然后该账号将拥有此 AMI 并存储其在某个 region 上，存储 AMI 到某个 region 会被收取一些费用。  
你无法直接共享加密的 AMI，可行的方法是：  
1. 复制快照并使用你的密钥重加密
2. 分享此 AMI 的用户需同时给你源快照及用于创建那个加密 AMI 的加密钥匙
3. 你会拥有复制的快照并注册其成为新的 AMI  
  
其他 AMI 限制：  
* 你不能直接复制 billingProducts code（用于 AWS Marketplace 的 Windows、RedHat 等）
* billingProducts code 用于支付比如 Windows Server 或 SQL Server 一类的使用许可
* 不能直接复制 billingProducts code 但是可以通过共享 AMI 启动一个实例然后再基于该实例创建 AMI 来复制此信息  
  
