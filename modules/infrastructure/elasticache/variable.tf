##variable for redis elasticache db
variable "redis_subnet_group_name" {
  type = string
  description = "The name of the redis elasticache subnet group"
}

variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}