##variable for rds subnet group
variable "rds_subnet_group_name" {
  type = string
  description = "The name of the rds subnet group"
}

variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}

variable "postgres_username" {
  type = string
  description = "The username for postgres db"
}

variable "mysql_username" {
  type = string
  description = "The username for mysql db"
}

variable "rds_security_group_id" {
  type = string
  description = "The ID of the RDS security group"
}

variable "vpc_id" {
  type = string
  description = "The VPC ID"
}

