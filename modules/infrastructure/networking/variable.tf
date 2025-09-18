####vpc variables

variable "cidr" {
  type = string
  description = "The cidr block for the vpc"
}

variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "The cidr block for the public subnets"
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "The cidr block for the private subnets"
}

variable "environment" {
  type = string
  description = "The environment name"
}

