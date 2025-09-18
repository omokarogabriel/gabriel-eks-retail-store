output "rds_subnet_group_name" {
  description = "The name of the RDS subnet group."
  value       = aws_db_subnet_group.rds_subnet_group.name
}

output "rds_subnet_group_id" {
  description = "The ID of the RDS subnet group."
  value       = aws_db_subnet_group.rds_subnet_group.id
}

output "postgres_instance_id" {
  description = "The ID of the Postgres RDS instance."
  value       = aws_db_instance.postgres.id
}

output "postgres_instance_endpoint" {
  description = "The endpoint of the Postgres RDS instance."
  value       = aws_db_instance.postgres.endpoint
}

output "mysql_instance_id" {
  description = "The ID of the MySQL RDS instance."
  value       = aws_db_instance.mysql.id
}

output "mysql_instance_endpoint" {
  description = "The endpoint of the MySQL RDS instance."
  value       = aws_db_instance.mysql.endpoint
}
