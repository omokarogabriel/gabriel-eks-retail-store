##provider variable
variable "region" {
  type = string
  description = "The region or location for the cloud provider(aws)"
}

variable "namespace" {
  type = string
  description = "The namespace for the resources"
}

variable "service_account_name" {
  type = string
  description = "The name of the service account" 
}