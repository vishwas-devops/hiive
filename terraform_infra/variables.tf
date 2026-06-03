variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_desired_size" {
  type    = number
  default = 2
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
  type    = string
  default = "hello-world"
}

variable "app_namespace" {
  type    = string
  default = "hiive"
}

variable "app_replicas" {
  type    = number
  default = 2
}

variable "app_image_tag" {
  type    = string
  default = "latest"
}

variable "log_retention_days" {
  type    = number
  default = 14
}
