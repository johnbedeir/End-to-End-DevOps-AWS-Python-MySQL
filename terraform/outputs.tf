output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "ecr_app_repository_name" {
  value = aws_ecr_repository.ecr_repo.name
}

output "ecr_db_repository_name" {
  value = aws_ecr_repository.ecr_repo_2.name
}

output "rds_cluster_endpoint" {
  value = aws_rds_cluster.rds_cluster.endpoint
}

output "rds_cluster_port" {
  value = aws_rds_cluster.rds_cluster.port
}

output "db_username" {
  sensitive = true
  value     = var.db_username
}

output "db_password" {
  sensitive = true
  value     = random_password.password.result
}

output "final_snapshot_name" {
  description = "The name of the final snapshot created when the RDS cluster is deleted"
  value       = aws_rds_cluster.rds_cluster.final_snapshot_identifier
}
