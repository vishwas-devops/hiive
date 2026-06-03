
variable "name" {
  type        = string
  description = "Name prefix for ECR resources"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"
}
