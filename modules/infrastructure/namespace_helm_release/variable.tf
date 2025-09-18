##variables for namesppace
variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}

variable "namespace" {
  type = string
  description = "The name of the namespace for helm release"
}

# variable "image_cart" {
#   type = string
#   description = "The cart image"
# }

# variable "image_cart_tag" {
#   type = string
#   description = "The tag for the cart image"
# }

# variable "image_catalog" {
#   type = string
#   description = "The image for catalog"
# }

# variable "image_catalog_tag" {
#   type = string
#   description = "The tag for the catalog image"
# }

# variable "image_checkout" {
#   type = string
#   description = "The image for checkout"
# }

# variable "image_checkout_tag" {
#   type = string
#   description = "The tag for the checkout image"
# }

# variable "image_orders" {
#   type = string
#   description = "The image for orders"
# }

# variable "image_orders_tag" {
#   type = string
#   description = "The tag for the orders image"
# }

# variable "image_ui" {
#   type = string
#   description = "The image for ui"
# }

# variable "image_ui_tag" {
#   type = string
#   description = "The tag for ui image"
# }