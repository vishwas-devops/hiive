variable "namespace" {
  type        = string
  description = "Kubernetes namespace for the application"
}

variable "app_name" {
  type        = string
  description = "Application name"
}

variable "image_uri" {
  type        = string
  description = "Container image URI from private ECR"
}

variable "replicas" {
  type        = number
  description = "Number of application replicas"
}
