### A Cloud Guru
  
Type of API:  
1. REST APIs (use JSON)
2. SOAP APIs (use XML)
  
What is AWS API Gateway:  
一个可以让开发者更容易发布、维护、监控、安全保护、auto scale 开发者的 API 的服务。可以用于 Lambda、EC2上运行的程序应用以及其他任何程序应用、后端服务、数据库（如DynamoDB）上。  
可以通过客户端直接发送 HTTP 请求到 API Gateway 上配置的 endpoint 以调用以上例举的后端服务。  
  
What API Gateway can do?  
* Expose HTTPS endpoints to define a RESTful API.
* Serverless-ly connect to services like Lambda & DynamoDB.
* Send each API endpoint to a different target.
* Run efficiently with low cost.
* Scale effortlessly.
* Track and control usage by API key.
* Throttle requests to prevent attacks.
* Connect to CloudWatch to log all requests for monitoring.
* Maintain multiple versions of API.
  
How to configure API Gateway?  
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
  
What is API Caching?  
API Caching 可以缓存你的 endpoint 响应（比如多次请求中请求的 endpoint 和参数都是一样的，则响应多数情况下也应是一样的，因此可以直接调用上次缓存的相同请求的响应结果如 JSON 来响应这些类似的新请求）。这样可以有效减少 endpoint 调用次数以及减少服务端延迟等等问题。当启用 API Caching 后，可设置一个 TTL（time-to-live） period 来决定缓存保留多长时间再更新（重新真正调用 endpoint 来计算新的响应结果）。缓存通常用于较频繁且类似的 API 调用请求。
  
Same Origin Policy  
这是现今一个重要的 web 应用安全模型（model），就是后端经过设置可以通知浏览器会阻止与后端 API 域名不同的客户端前端应用的脚本程序向该后端发送请求。这一机制可以有效阻止 XSS（Cross-Site Scripting） 攻击。  
* Enforced by web browsers.
* Ignored by tools like PostMan and curl.
  
Cross Origin Resource Sharing (CORS)  
即后端服务允许放开 Same Origin Policy。此机制允许某些限制的资源（如字体）被任意域名的前端应用程序访问。  
* 浏览器发送一个 HTTP OPTIONS 请求到 URL（服务端 endpoint）。（HTTP OPTIONS 是一个 HTTP method，如 GET、POST）
* 服务端响应回复: "These other domains are approved to GET this URL."
* 否则回复 Error: "Origin policy cannot be read at the remote resource?" 这意味着该 API Gateway 需要启用 CORS。
  
Exam Tips:  
* Remember what API Gateway is at the high level.
* API Gateway has caching capabilities to increase performance.
* API Gateway is low cost and scales automatically.
* Can throttle API Gateway to prevent attacks.
* Can log results to CloudWatch.
* If using JavaScript/Ajax that uses multiple domains with API Gateway, ensure that have enabled CORS on API Gateway.
* CORS is enforced by the client.