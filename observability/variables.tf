variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID to integrate with Datadog"
}

variable "datadog_api_url" {
  type    = string
  default = "https://api.datadoghq.com"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "service_name" {
  type    = string
  default = "tes"
}

variable "eks_cluster_name" {
  type    = string
  default = "test"
}

variable "alert_channel" {
  type    = string
  default = "@pagerduty-hive-platform-team"
}
