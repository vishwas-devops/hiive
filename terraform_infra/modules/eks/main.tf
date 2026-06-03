module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.name}-eks"
  kubernetes_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  endpoint_public_access  = false
  endpoint_private_access = true

  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled = false
  }

  eks_managed_node_groups = {
    default = {
      name = "${var.name}-mng"

      instance_types = var.node_instance_types

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      subnet_ids = var.private_subnet_ids

      labels = {
        workload = "general"
      }
    }
  }

  tags = var.tags
}
