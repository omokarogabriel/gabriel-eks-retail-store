##variable for the secret
variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}

variable "namespace" {
  type        = string
  description = "Namespace for secrets."
  default     = "default"
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