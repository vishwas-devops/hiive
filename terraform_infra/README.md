# Hiive Terraform EKS Assignment

## Overview

This terraform code will deploys a simple containerized application to a private AWS EKS cluster.

Terraform will create below AWS resources:

- VPC
- Private subnets
- No Internet Gateway
- No NAT Gateway
- VPC endpoints for private AWS service access
- Private Amazon ECR repository
- AWS EKS cluster
- EKS managed node group
- Kubernetes namespace, deployment, and service
- Basic CloudWatch observability

The EKS cluster endpoint is private and is not publicly exposed to the internet.

---

## Architecture

```text
Private VPC
├── Private Subnet 1
├── Private Subnet 2
├── VPC Endpoints
│   ├── ECR API
│   ├── ECR Docker
│   ├── S3
│   ├── STS
│   └── CloudWatch Logs
├── Private ECR Repository
├── Private EKS Cluster
│   └── Managed Node Group
└── Kubernetes App
    ├── Deployment
    └── ClusterIP Service
