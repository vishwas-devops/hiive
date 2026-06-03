# Hiive Terraform EKS Assignment

## Overview

This terraform code will deploys a simple containerized application to a private AWS EKS cluster.

Terraform will create below AWS resources:

* VPC
* Private subnets
* No Internet Gateway
* No NAT Gateway
* VPC endpoints for private AWS service access
* Private Amazon ECR repository
* AWS EKS cluster
* EKS managed node group
* Kubernetes namespace, deployment, and service
* Basic CloudWatch observability

The EKS cluster endpoint is private and is not publicly exposed to the internet.

---

# Architecture

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
```

---

# Important Things to Remember


> Cluster is not publiclly exposed and can still pull from public repos and to achieve this, we uses a private ECR-based image strategy.

The image is pushed or mirrored into private Amazon ECR, and the EKS nodes pull it privately using VPC endpoints.

This means:

```text
No Internet Gateway
No NAT Gateway
No public worker nodes
No public Kubernetes API endpoint
Private image pulls through ECR + VPC endpoints
```

---

# Repository Structure

```text
terraform-infra/
├── providers.tf
├── variables.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars.example
└── modules/
    ├── vpc/
    ├── ecr/
    ├── eks/
    ├── app/
    └── observability/
```

---

# Modules

## 1. Networking Module

Creates:

* VPC
* Private subnets
* Private route table
* VPC endpoints

This module intentionally does not create:

* Internet Gateway
* NAT Gateway
* Public subnets
* Public route table

### Why?

The assignment specifically requires:

```text
No internet gateway
Cluster not publicly exposed
```

This design ensures the EKS worker nodes remain fully private.

---

## 2. ECR Module

Creates a private Amazon ECR repository for the application image.

This allows EKS nodes to pull the image privately without internet access.


---

## 3. EKS Module

Creates:

* Private EKS cluster
* Private Kubernetes API endpoint
* EKS managed node group
* Control plane logging


---

## 4. App Module

Deploys:

* Kubernetes namespace
* Deployment
* ClusterIP service

The application is internal-only by default.

## 5. Observability Module

Creates:

* CloudWatch log group
* Basic CloudWatch alarms for node CPU and memory

### Included Monitoring

* EKS control plane logs
* High node CPU alarm
* High node memory alarm

---

# Prerequisites

Install:

* Terraform
* AWS CLI
* kubectl
* Docker

Verify AWS access:

```bash
aws sts get-caller-identity
```

---

# Step 1: Clone Repository

```bash
git clone <your-repository-url>
cd hiive
```

---

# Step 2: Use Terraform Variables File

---

# Step 3: Initialize Terraform

```bash
terraform init
```

---

# Step 4: Review Terraform Plan

```bash
terraform plan
```

---

# Step 5: Deploy Core Infrastructure

Because the Kubernetes API endpoint is private, the Kubernetes resources may require private network access during deployment.

Deploy infrastructure first:

```bash
terraform apply \
  -target=module.vpc \
  -target=module.ecr \
  -target=module.eks \
  -target=module.observability
```

This creates:

* VPC
* Private subnets
* VPC endpoints
* ECR
* EKS cluster
* Node group
* CloudWatch alarms

---

# Step 6: Push Application Image to ECR

Get ECR repository URL:

```bash
terraform output ecr_repository_url
```

Login to ECR:

```bash
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.us-east-1.amazonaws.com
```

Build Docker image:

```bash
docker build -t hello-world .
```

Tag image:

```bash
docker tag hello-world:latest <ecr-repository-url>:latest
```

Push image:

```bash
docker push <ecr-repository-url>:latest
```

---

# Step 7: Access Private EKS Cluster

Because the EKS API endpoint is private, kubectl access must come from:

* VPN-connected workstation
* Bastion host
* SSM-managed EC2 instance
* CI/CD runner inside the VPC

Update kubeconfig:

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name hiive-dev-eks
```

Verify cluster access:

```bash
kubectl get nodes
```

---

# Step 8: Deploy Application

Deploy the Kubernetes application:

```bash
terraform apply -target=module.app
```

---

# Step 9: Verify Deployment

Check nodes:

```bash
kubectl get nodes
```

Check pods:

```bash
kubectl get pods -n hiive
```

Check services:

```bash
kubectl get svc -n hiive
```

Expected service type:

```text
ClusterIP
```

This means the app is private and only reachable inside the cluster.

---

# How Would I Expose This Application Without a Public EKS Endpoint?

A public EKS endpoint is not required to expose an application.

The EKS endpoint controls Kubernetes API access. Application traffic is separate.

To expose the application publicly, I would use:

* AWS Load Balancer Controller
* Kubernetes Ingress
* Internet-facing Application Load Balancer
* Route 53 DNS
* ACM TLS certificate
* AWS WAF

Traffic flow:

```text
User
→ Route 53
→ Public ALB
→ Private EKS Worker Nodes
→ Kubernetes Service
→ Application Pods
```

The Kubernetes API endpoint would remain private.

---

# Security Decisions and Tradeoffs

## Private EKS Endpoint

The Kubernetes API endpoint is private.

### Benefit

* Reduces public attack surface
* Prevents direct internet access to the Kubernetes control plane

### Tradeoff

* Engineers need VPN, bastion, SSM, or private CI/CD runner access

---

## No Internet Gateway or NAT Gateway

The VPC intentionally does not include:

* Internet Gateway
* NAT Gateway

### Benefit

* Strong network isolation
* No direct outbound internet access from worker nodes

### Tradeoff

* Nodes cannot directly pull from Docker Hub
* Private ECR and VPC endpoints are required

---

## Private ECR Image Strategy

The application image is stored in private ECR.

### Benefit

* Supports private image pulls
* Works without internet access

### Tradeoff

* Requires image build and push process before deployment

---

## ClusterIP Service

The app uses:

```hcl
type = "ClusterIP"
```

### Benefit

* Application is private by default
* No accidental public exposure

### Tradeoff

* Application is not reachable publicly until ingress is configured

---

## Basic Observability

This project includes:

* EKS control plane logs
* CloudWatch alarms
* CloudWatch log retention

### Benefit

* Provides initial operational visibility

### Tradeoff

* Not full production observability

---

# What I Would Improve for Production

For a real production platform, I would add:

* Remote Terraform state using S3 + DynamoDB locking or use terraform enterprise
* CI/CD pipeline for Terraform plan and apply
* Private CI/CD runner inside VPC
* SSM Session Manager endpoints
* ECR pull-through cache for public image mirroring
* AWS Load Balancer Controller
* ACM TLS certificates
* Route 53 DNS
* AWS WAF
* Datadog Agent
* Datadog APM
* Centralized logging
* SLO dashboards
* PagerDuty
* IAM Roles for Service Accounts (IRSA)
* Kubernetes Network Policies
* External Secrets Operator
* Vault integration
* OPA Gatekeeper or Kyverno policy enforcement

---

# Cleanup

Destroy infrastructure:

```bash
terraform destroy
```

If the Kubernetes app was deployed separately, ensure application resources are deleted before removing the EKS cluster.

---

# Summary

This project deploys a secure private EKS deployment using Terraform.

The design prioritizes:

* Private networking
* No public EKS endpoint
* No Internet Gateway
* No NAT Gateway
* Private image pulls through ECR
* Internal-only application exposure
* Basic CloudWatch observability
* Modular Terraform structure
