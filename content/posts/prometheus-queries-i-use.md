---
title:  "Prometheus queries I use"
date: 2024-08-07T17:51:06+01:00
draft: false
---

## High cardinality metrics

```
count({__name__=~".+"}) by (__name__)
```

Very practical to find the amount of timeseries (you need to suspect some). Often span metrics or Kubernetes metrics may surprise, so if suspect any of those try something like

```
count({__name__=~"calls.*|kube.*"}) by (name, job)
```

## Topk – largest k elements by sample value

```
topk(k, <metric_expression>)
```

## Top 5 CPU usage metrics

```
topk(5, sum(rate(container_cpu_usage_seconds_total[5m])) by (container_name))
```

This query calculates the rate of CPU usage for each container over the last 5 minutes, sums it up by container_name, and then returns the top 5 containers with the highest CPU usage.

## Top 10 HTTP Request Rates

```
topk(10, sum(rate(http_requests_total[5m])) by (instance))
```

This query calculates the rate of HTTP requests for each instance over the last 5 minutes and then returns the top 10 instances with the highest request rates.
Request rate
Throughput

Note: below examples are true for the span metrics generated with the Otel connector.

## Rate of processed requests can be queries as follows:

```
sum(rate(duration_seconds_count{job:<service_name>}[5m]))
```

The output timeseries is measured in requests per seconds (RPS).

If you prefer to see requests per minute (RPM) then multiply it by 60:

```
sum(rate(duration_seconds_count{job:<service_name>}[5m])) * 60
```

## Hit rate

It might be interesting to look at the rate of hits the service. Ideally it should be close to the throughput. Throughput rate cannot be higher than the hit rate. As before – its hits per seconds.

```
sum(rate(calls_total{}[5m]))
```

## P95 response duration

```
histogram_quantile(0.95, 
    sum(
        rate(
            duration_seconds_bucket{span_kind=~"SPAN_KIND_SERVER|SPAN_KIND_CONSUMER", job=<service_name>} [5m]
        )
    ) by (le)
)
```