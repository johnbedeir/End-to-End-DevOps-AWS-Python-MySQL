output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "ecr_repository_name" {
  value = aws_ecr_repository.ecr_repo.name
}

output "rds_cluster_endpoint" {
  value = aws_rds_cluster.rds_cluster.endpoint
}

output "rds_cluster_port" {
  value = aws_rds_cluster.rds_cluster.port
}
