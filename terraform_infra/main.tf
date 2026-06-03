# VPC Creation

module "vpc" {
  source = "./modules/vpc"

  name                 = local.name
  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = local.tags
}


# ECR Creation

module "ecr" {
  source = "./modules/ecr"

  name = local.name
  tags = local.tags
}

# EKS Creating

module "eks" {
  source = "./modules/eks"

  name               = local.name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_version     = var.cluster_version
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size

  tags = local.tags

  depends_on = [
    module.vpc
  ]
}

# App creation

module "app" {
  source = "./modules/app"

  namespace = var.app_namespace
  app_name  = var.app_name
  image_uri = "${module.ecr.repository_url}:${var.app_image_tag}"
  replicas  = var.app_replicas

  depends_on = [
    module.eks,
    module.ecr
  ]
}

# Observability Creation
module "observability" {
  source = "./modules/observability"

  name               = local.name
  cluster_name       = module.eks.cluster_name
  log_retention_days = var.log_retention_days
  tags               = local.tags

  depends_on = [
    module.eks
  ]
}

# EC2 Instnace Creation

module "workstation" {
  source = "./modules/workstation"

  name              = local.name
  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = module.vpc.vpc_cidr
  private_subnet_id = module.vpc.private_subnet_ids[0]
  instance_type     = "t3.micro"
  tags              = local.tags

  depends_on = [
    module.networking
  ]
}
