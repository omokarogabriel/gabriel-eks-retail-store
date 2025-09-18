output "mysql_secret_arn" {
  description = "ARN of the MySQL password secret"
  value       = aws_secretsmanager_secret.mysql_password.arn
}

output "postgres_secret_arn" {
  description = "ARN of the PostgreSQL password secret"
  value       = aws_secretsmanager_secret.postgres_password.arn
}