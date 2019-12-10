# A Cloud Guru
  
## Cost Explorer & Cost Allocation Tags
Cost Explorer 是一个 AWS 服务，可以帮助你查看和分析你在 AWS 资源、服务上的支出及使用情况（通过 graph、报告、Cost Explore RI 报告）。  
可以历史保留 13 个月的数据，或可以预估后 3 个月的支出与使用，然后获取建议如使用哪一类 reserved instance。  
  
还可以生成 Cost Allocation CSV 报告。  
要生成该报告，先 tag 你的 AWS 资源（Configure tags for cost center, such as by development、employee id etc），然后在 Billing and Cost Management 控制台的 Cost Allocation Tags 中激活 tags。  
报告会根据 tag 对支出与使用情况进行分组。  
tag 可以是根据业务类型、关键词命名，从而可以更好地理解、组织。  
  
## Lab
Cost Explorer 和 Cost Allocation Tags 服务均在 Billing and Cost Management 控制台的左侧选项卡中。  
  
## 适用范围
Cost Explorer 是针对、统计整个 Organization 的，所以会统计 Org 下的所有 AWS Accounts 的资源、服务使用。  
