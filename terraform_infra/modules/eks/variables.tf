
variable "name" {
  type        = string
  description = "Name prefix for EKS resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for EKS worker nodes"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for EKS"
}

variable "node_instance_types" {
  type        = list(string)
  description = "EC2 instance types for EKS managed nodes"
}

variable "node_desired_size" {
  type        = number
  description = "Desired number of worker nodes"
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of worker nodes"
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of worker nodes"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
}
