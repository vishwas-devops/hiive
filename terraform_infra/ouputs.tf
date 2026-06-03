output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "app_namespace" {
  value = module.app.namespace
}

output "app_service_name" {
  value = module.app.service_name
}

output "application_log_group_name" {
  value = module.observability.application_log_group_name
}
output "workstation_instance_id" {
  value = module.workstation.instance_id
}

output "workstation_private_ip" {
  value = module.workstation.private_ip
}
