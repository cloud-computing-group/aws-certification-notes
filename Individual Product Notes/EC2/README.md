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
  
