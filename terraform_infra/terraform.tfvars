
aws_region   = "us-east-1"
project_name = "hiive"
environment  = "prod"

vpc_cidr = "10.20.0.0/16"

private_subnet_cidrs = [
  "10.20.1.0/24",
  "10.20.2.0/24"
]

availability_zones = [
  "us-east-1a",
  "us-east-1b"
]

cluster_version = "1.30"

node_instance_types = ["t3.medium"]

node_desired_size = 2
node_min_size     = 2
node_max_size     = 3

app_name      = "hello-world"
app_namespace = "hiive"
app_replicas  = 2
app_image_tag = "latest"

log_retention_days = 14
