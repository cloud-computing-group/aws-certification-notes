## CSAA Test Notes:  
* Limite 50 domain names, can contact AWS to expand.
* Simple routing: one record for multiple IP, rotating by random order, no health check.
* Multivalue routing: multiple values, with health check.
* Health check on endpoint, state of CloudWatch alarms, status of other health checks.