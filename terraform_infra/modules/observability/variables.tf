variable "name" {
  type        = string
  description = "Name prefix for observability resources"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention in days"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"
}
