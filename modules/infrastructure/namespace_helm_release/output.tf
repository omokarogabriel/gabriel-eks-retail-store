output "namespace_name" {
  description = "The name of the Kubernetes namespace."
  value       = kubernetes_namespace.retail_ns.metadata[0].name
}

# output "helm_release_cart_name" {
#   description = "The name of the cart Helm release."
#   value       = helm_release.cart.name
# }

# output "helm_release_catalog_name" {
#   description = "The name of the catalog Helm release."
#   value       = helm_release.catalog.name
# }

# output "helm_release_checkout_name" {
#   description = "The name of the checkout Helm release."
#   value       = helm_release.checkout.name
# }

# output "helm_release_orders_name" {
#   description = "The name of the orders Helm release."
#   value       = helm_release.orders.name
# }

# output "helm_release_ui_name" {
#   description = "The name of the UI Helm release."
#   value       = helm_release.ui.name
# }
