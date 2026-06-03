# VPC Creation

module "networking" {
  source = "./modules/networking"

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
