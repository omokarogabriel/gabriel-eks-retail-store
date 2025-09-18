###variable for the iam
variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}

variable "sa_role_name" {
  type = string
  description = "The name of the service account role"  
}

variable "namespace" {
  type = string
  description = "The namespace for the service account"
}

variable "service_account_name" {
  type = string
  description = "The name of the service account"
}