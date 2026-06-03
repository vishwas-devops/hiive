variable "aws_region" {
  type        = string
  description = "AWS region where resources will be created"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_cidr" {
  type        = string
  description = "Main CIDR block for the VPC"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for private subnets"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for EKS"
  default     = "1.30"
}

variable "node_instance_types" {
  type        = list(string)
  description = "EC2 instance types for EKS nodes"
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  type        = number
  default     = 2
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 3
}

variable "app_name" {
  type        = string
  default     = "hello-world"
  description = "Application name"
}

variable "app_namespace" {
  type        = string
  default     = "hiive"
  description = "Kubernetes namespace for the app"
}

variable "app_replicas" {
  type        = number
  default     = 2
  description = "Number of app replicas"
}

variable "app_image_tag" {
  type        = string
  default     = "latest"
  description = "Application image tag"
}
