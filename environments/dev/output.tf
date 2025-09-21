output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role"
  value       = module.iam.github_actions_role_arn
}

output "aws_load_balancer_controller_role_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM role"
  value       = module.iam.aws_load_balancer_controller_role_arn
}

output "eks_cluster_name" {
  value = module.eks_cluster.eks_cluster_name
}

output "mysql_instance_endpoint" {
  value = module.rds.mysql_instance_endpoint
}

output "postgres_instance_endpoint" {
  value = module.rds.postgres_instance_endpoint
}

output "redis_cluster_endpoint" {
  value = module.elasticache.redis_cluster_endpoint
}

output "redis_cluster_port" {
  value = module.elasticache.redis_cluster_port
}

output "dynamodb_table_name" {
  value = module.dynamodb.dynamodb_table_name
}

output "postgres_secret_name" {
  value = module.secrets.postgres_secret_name
}

output "mysql_secret_name" {
  value = module.secrets.mysql_secret_name
}