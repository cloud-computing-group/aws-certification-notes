### Kinesis
有三部分：
1. Kinesis Stream - 实时处理（如读取、转发、动态改变策略、启动警报等等）大量流数据，可用于实时的数据分析、实时的报告、复杂的交叉的流数据分析等等，支持多应用并行读取。
2. Kinesis Analytics - 实时地以 SQL 分析流数据。
3. Kinesis Firehose - 加载流数据到服务（比如 redshift）里  
  
Kinesis Stream：Producer（KPL） & Consumer（KCL），Kinesis Stream 还支持 Agent 和 API。  
Producer 可以是比如联网设备，Consumer 可以是比如 EC2 实例及其应用程序。