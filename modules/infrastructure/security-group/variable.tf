##variable for security group
variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}

variable "cidr" {
  type = string
  description = "The vpc cidr block"
}

variable "vpc_id" {
  type = string
  description = "The VPC ID"
}