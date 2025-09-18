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

