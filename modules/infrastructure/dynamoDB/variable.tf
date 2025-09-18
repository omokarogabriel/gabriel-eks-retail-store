##variable for dynamoDB
variable "dynamodb_name" {
  type = string
  description = "The name for dynamoDB table"
}

variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}