## A Cloud Guru
  
### Type of API:  
1. REST APIs (use JSON)
2. SOAP APIs (use XML)
  
### What is AWS API Gateway:  
一个可以让开发者更容易发布、维护、监控、安全保护、auto scale 开发者的 API 的服务。可以用于 Lambda、EC2上运行的程序应用以及其他任何程序应用、后端服务、数据库（如DynamoDB）上。  
可以通过客户端直接发送 HTTP 请求到 API Gateway 上配置的 endpoint 以调用以上例举的后端服务。  
  
### What API Gateway can do?  
* Expose HTTPS endpoints to define a RESTful API.
* Serverless-ly connect to services like Lambda & DynamoDB.
* Send each API endpoint to a different target.
* Run efficiently with low cost.
* Scale effortlessly.
* Track and control usage by API key.
* Throttle requests to prevent attacks.
* Connect to CloudWatch to log all requests for monitoring.
* Maintain multiple versions of API.
  
### How to configure API Gateway?  
* Define an API (container).
* Define Resources and nested Resources. (URL paths)
* For each Resource:
    * Select supported HTTP methods (verbs)
    * Set security
    * Choose target (such as EC2, Lambda, DynamoDB etc)
    * Set request and response transformations
* Deploy API to a Stage (prod, tags or anything else)
    * Uses API Gateway domain by default.
    * Can use custom domain.
    * Support AWS Certificate Manager: free SSL/TLS certs.
  
### What is API Caching?  
API Caching 可以缓存你的 endpoint 响应（比如多次请求中请求的 endpoint 和参数都是一样的，则响应多数情况下也应是一样的，因此可以直接调用上次缓存的相同请求的响应结果如 JSON 来响应这些类似的新请求）。这样可以有效减少 endpoint 调用次数以及减少服务端延迟等等问题。当启用 API Caching 后，可设置一个 TTL（time-to-live） period 来决定缓存保留多长时间再更新（重新真正调用 endpoint 来计算新的响应结果）。缓存通常用于较频繁且类似的 API 调用请求。
  
### Same Origin Policy  
这是现今一个重要的 web 应用安全模型（model），就是后端经过设置可以通知浏览器会阻止与后端 API 域名不同的客户端前端应用的脚本程序向该后端发送请求。这一机制可以有效阻止 XSS（Cross-Site Scripting） 攻击。  
* Enforced by web browsers.
* Ignored by tools like PostMan and curl.
  
### Cross Origin Resource Sharing (CORS)  
即后端服务允许放开 Same Origin Policy。此机制允许某些限制的资源（如字体）被任意域名的前端应用程序访问。  
* 浏览器发送一个 HTTP OPTIONS 请求到 URL（服务端 endpoint）。（HTTP OPTIONS 是一个 HTTP method，如 GET、POST）
* 服务端响应回复: "These other domains are approved to GET this URL."
* 否则回复 Error: "Origin policy cannot be read at the remote resource?" 这意味着该 API Gateway 需要启用 CORS。
  
### Exam Tips:  
* Remember what API Gateway is at the high level.
* API Gateway has caching capabilities to increase performance.
* API Gateway is low cost and scales automatically.
* Can throttle API Gateway to prevent attacks.
* Can log results to CloudWatch.
* If using JavaScript/Ajax that uses multiple domains with API Gateway, ensure that have enabled CORS on API Gateway.
* CORS is enforced by the client.
  
### Advanced API Gateway - Import APIs
开发者可以使用 API Gateway 的 API 导入功能导入在外部写好的 API 定义文件，比如 Swagger v2.0 定义文件就受到支持。有了 API 导入功能，开发者可以通过 POST 请求（调用 AWS API）（在payload 里携带 Swagger 定义信息以及 endpoint 配置信息）创建新的 API，也可以通过 PUT 请求（在payload 里携带 Swagger 定义信息）更新已有的 API（更新有两种方式：完全重写定义、与一个已有 API 合并定义，开发者可以通过在 HTTP 请求的目标URL里添加 mode query parameter 指定使用哪一种更新方式）。(通过 Swagger 创建 API 在 AWS API Gateway 的控制台里也可以执行）（Exam Tip: you can't import existing API using swagger file)  
  
### Advanced API Gateway - API Throttling（DDOS protect）
默认情况下，API Gateway 对 steady-state 请求的频率限制为 10000 requests per second (rps)。  
最大并发请求是 5000 个请求（这是同一 AWS 根账号的所有 API 的总限制）。  
如果你超过 10000 rps 或最大并发请求（5000），你会收到一个 `429 Too Many Request` 错误响应。  
更多具体信息：  
* 如果长时间持续地每一秒不多不少总是收到 10000 请求（均匀地每毫秒 10 个请求），API Gateway 都会正常处理不会丢失任何一个请求。
* 如果在某一秒内，第一个毫秒收到 10000 个请求，API Gateway 会只服务、处理其中 5000 个请求（使用最大并发请求处理），并在此 1 秒的剩余时间内限制、阻截任何剩余的、新的请求。
* 如果在某一秒内，第一个毫秒收到 5000 个请求，并在剩余的 999 毫秒里均匀地收到 5000 个请求（每毫秒 5 个请求），API Gateway 可以正常处理这全部 10000 个请求且不返回 `429 Too Many Request` 错误响应。
* 如果调用方在第一毫秒提交 5000 个请求，然后等到第 101 毫秒再提交另外 5000 个请求，则 API Gateway 会处理 6000 个请求，并限制一秒内的剩余请求数量。这是因为，在 10000 rps 的速率下，API Gateway 已经在前 100 毫秒响应了 1000 个请求，因此清空了同样数量的存储桶。在接下来的 5000 个请求高峰中，有 1000 个请求会进入存储桶并排队等待处理。其他 4000 个超出存储桶容量的请求会被丢弃。
* 如果调用方在第一毫秒提交 5000 个请求，在第 101 毫秒提交 1000 个请求，然后在剩余 899 毫秒内均匀提交另外 4000 个请求，则 API Gateway 会在一秒内处理所有 10000 个请求，不会施加限制。
  
### Advanced API Gateway - SOAP Webservice Passthrough
开发者可以配置 API Gateway 来使其作为 SOAP Webservice Passthrough。（https://www.rubix.nl/blogs/how-configure-amazon-api-gateway-soap-webservice-passthrough-minutes/ ）
  
### Advanced API Gateway - Exam Tips:
* Import API's using Swagger 2.0 definition files
* API Gateway can be throttled（开发者可以设置默认方法限制）
    * Default limits are 10000 rps or 5000 concurrently
* You can configure API Gateway as a SOAP Webservice passthrough
