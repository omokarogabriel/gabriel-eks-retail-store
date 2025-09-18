##variable for security group
variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}

variable "cidr" {
  type = string
  description = "The vpc cidr block"
}