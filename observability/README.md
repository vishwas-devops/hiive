# Hiive Observability Setup with Datadog

## Overview

This project defines an observability setup for a production-style platform using Datadog, AWS, and Terraform.

The goal is to monitor application health, infrastructure health, Kubernetes/EKS workloads, and reliability against SLA/SLO targets.

## What This Terraform Does

This Terraform configuration connects an AWS account to Datadog.

It creates:

1. An IAM role in AWS for Datadog
2. An IAM policy with required read-only permissions
3. A trust relationship that allows Datadog to assume the role
4. A Datadog AWS integration
5. Account-level tags such as environment and platform name

Once applied, Datadog can collect AWS metrics from services such as:

- EC2
- EKS
- RDS
- Load Balancers
- CloudWatch
- Auto Scaling
- Networking resources

## Why This Is Important

This allows the platform team to monitor:

- API errors
- API latency
- Kubernetes pod health
- EKS node saturation
- Database performance
- Infrastructure availability
- Service reliability

## Observability Approach

For Hiive’s platform, I would configure Datadog across four major areas:

### 1. Application Performance Monitoring

Datadog APM would be used to track:

- Request latency
- Error rate
- Throughput
- Slow endpoints
- Database query latency
- Service-to-service dependencies

### 2. Infrastructure Monitoring

AWS infrastructure metrics would be collected from CloudWatch into Datadog.

Important metrics include:

- EC2 CPU and memory
- EKS node health
- RDS CPU, connections, and latency
- Load balancer 5xx errors
- Network errors

### 3. Kubernetes / EKS Monitoring

The Datadog Agent would run inside EKS as a DaemonSet using the Datadog Helm chart.

It would monitor:

- Pod restarts
- CrashLoopBackOff
- Pending pods
- Deployment availability
- Node memory pressure
- Node CPU pressure
- Container resource usage

### 4. Logs and Traces

Application logs, Kubernetes logs, and infrastructure logs would be shipped to Datadog.

Logs would be correlated with APM traces so that engineers can move from an alert to the exact failing request, log line, pod, or database call.

## SLA and SLO Strategy

I would define SLOs for the most customer-impacting services.

Example SLOs:

| Area | Target |
|---|---|
| API availability | 99.9% |
| API latency | p95 under 500ms |
| API error rate | Less than 1% 5xx |
| Background jobs | 99% success rate |
| Kubernetes availability | Critical deployments always available |

## Critical Alerts

The most important alerts would be:

| Alert | Severity | Why |
|---|---|---|
| High API 5xx rate | Critical | Direct customer impact |
| API p95 latency above SLO | Critical | Platform is degraded |
| Critical deployment unavailable | Critical | Service may be down |
| Pod restart spike | Critical | Possible bad deployment or runtime issue |
| EKS node saturation | Critical | Can cause cascading pod failures |
| Database connection saturation | Critical | Can impact the whole platform |

## How to Run

Set Datadog credentials as environment variables:

```bash
export DD_API_KEY="your-api-key"
export DD_APP_KEY="your-app-key"
