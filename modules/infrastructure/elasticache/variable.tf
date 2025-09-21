##variable for redis elasticache db
variable "redis_subnet_group_name" {
  type = string
  description = "The name of the redis elasticache subnet group"
}

variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}

variable "elasticache_security_group_id" {
  type = string
  description = "The ID of the ElastiCache security group"
}

variable "vpc_id" {
  type = string
  description = "The VPC ID"
}