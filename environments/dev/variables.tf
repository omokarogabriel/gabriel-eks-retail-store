variable "region" {
  type        = string
  description = "AWS region to deploy resources"    
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "sa_role_name" {
  type        = string
  description = "Name of the service account IAM role"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace for resources"
}

variable "service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account"
}

variable "rds_subnet_group_name" {
  type        = string
  description = "Name of the RDS subnet group"
}

variable "postgres_username" {
  type        = string
  description = "Username for PostgreSQL database"
  sensitive   = true
}

variable "mysql_username" {
  type        = string
  description = "Username for MySQL database"
  sensitive   = true
}

variable "dynamodb_name" {
  type        = string
  description = "Name of the DynamoDB table"
}

variable "redis_subnet_group_name" {
  type        = string
  description = "Name of the Redis ElastiCache subnet group"
}

variable "postgres_password" {
  type        = string
  description = "Password for PostgreSQL database"
  sensitive   = true
}

variable "mysql_password" {
  type        = string
  description = "Password for MySQL database"
  sensitive   = true
}