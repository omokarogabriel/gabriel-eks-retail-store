##namespace for helm - commented out until cluster is ready
# resource "kubernetes_namespace" "retail_ns" {
#   metadata {
#     name = "${var.vpc_name}-${var.namespace}"
#   }
# }

# Namespace will be created in application deployment phase



# resource "helm_release" "cart" {
#   name       = "frontend"
#   chart      = ""
#   namespace  = kubernetes_namespace.retail_ns.metadata[0].name
# #public.ecr.aws/aws-containers/retail-store-sample-cart
# #"1.2.4"
#   values = [
#     yamlencode({
#       image = { repository = var.image_cart, tag = var.image_cart_tag }
#       replicaCount = 2
#       service = { port = 8081 }
#       containerPort = 8081
#       env = [
#         # { name = "API_URL", value = "http://backend:8080" }
#         { name = "RETAIL_CART_PERSISTENCE_PROVIDER", value = "dynamodb" },
#         { name = "RETAIL_CART_PERSISTENCE_DYNAMODB_ENDPOINT", value = "http://carts-db:8000" },
#         { name = "AWS_ACCESS_KEY_ID", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_ACCESS_KEY_ID" } } },
#         { name = "AWS_SECRET_ACCESS_KEY", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_SECRET_ACCESS_KEY" } } }
#       ]
#     })
#   ]
# }



# resource "helm_release" "catalog" {
#   name       = "frontend"
#   chart      = ""
#   namespace  = kubernetes_namespace.retail_ns.metadata[0].name
# #public.ecr.aws/aws-containers/retail-store-sample-catalog
# #"1.2.4"
#   values = [
#     yamlencode({
#       image = { repository = var.image_catalog, tag = var.image_catalog_tag }
#       replicaCount = 2
#       service = { port = 8082 }
#       containerPort = 8082
#       env = [
#         # { name = "API_URL", value = "http://backend:8080" }
#         { name = "RETAIL_CART_PERSISTENCE_PROVIDER", value = "dynamodb" },
#         { name = "RETAIL_CART_PERSISTENCE_DYNAMODB_ENDPOINT", value = "http://carts-db:8000" },
#         { name = "AWS_ACCESS_KEY_ID", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_ACCESS_KEY_ID" } } },
#         { name = "AWS_SECRET_ACCESS_KEY", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_SECRET_ACCESS_KEY" } } }
#       ]
#     })
#   ]
# }

# resource "helm_release" "checkout" {
#   name       = "frontend"
#   chart      = "./charts/service"
#   namespace  = kubernetes_namespace.retail_ns.metadata[0].name
# #public.ecr.aws/aws-containers/retail-store-sample-checkout
# #"1.2.4"
#   values = [
#     yamlencode({
#       image = { repository = var.image_checkout, tag = var.image_checkout_tag }
#       replicaCount = 2
#       service = { port = 8083 }
#       containerPort = 8083
      
#       env = [
#         # { name = "API_URL", value = "http://backend:8080" }
#         { name = "RETAIL_CART_PERSISTENCE_PROVIDER", value = "dynamodb" },
#         { name = "RETAIL_CART_PERSISTENCE_DYNAMODB_ENDPOINT", value = "http://carts-db:8000" },
#         { name = "AWS_ACCESS_KEY_ID", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_ACCESS_KEY_ID" } } },
#         { name = "AWS_SECRET_ACCESS_KEY", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_SECRET_ACCESS_KEY" } } }
#       ]
#     })
#   ]
# }

# resource "helm_release" "orders" {
#   name       = "frontend"
#   chart      = "./charts/service"
#   namespace  = kubernetes_namespace.retail_ns.metadata[0].name
# #public.ecr.aws/aws-containers/retail-store-sample-orders
# #"1.2.4"

#   values = [
#     yamlencode({
#       image = { repository = var.image_orders, tag = var.image_orders_tag }
#       replicaCount = 2
#       service = { port = 8084 }
#       containerPort = 8084
#       env = [
#         # { name = "API_URL", value = "http://backend:8080" }
#         { name = "RETAIL_CART_PERSISTENCE_PROVIDER", value = "dynamodb" },
#         { name = "RETAIL_CART_PERSISTENCE_DYNAMODB_ENDPOINT", value = "http://carts-db:8000" },
#         { name = "AWS_ACCESS_KEY_ID", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_ACCESS_KEY_ID" } } },
#         { name = "AWS_SECRET_ACCESS_KEY", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_SECRET_ACCESS_KEY" } } }
#       ]
#     })
#   ]
# }


# resource "helm_release" "ui" {
#   name       = "frontend"
#   chart      = "./charts/service"
#   namespace  = kubernetes_namespace.retail_ns.metadata[0].name

# #public.ecr.aws/aws-containers/retail-store-sample-ui
# #"1.2.4"
#   values = [
#     yamlencode({
#       image = { repository = var.image_ui, tag = var.image_ui_tag }
#       replicaCount = 2
#       service = { port = 8080 }
#       containerPort = 8080
#       env = [
#         # { name = "API_URL", value = "http://backend:8080" }
#         { name = "RETAIL_CART_PERSISTENCE_PROVIDER", value = "dynamodb" },
#         { name = "RETAIL_CART_PERSISTENCE_DYNAMODB_ENDPOINT", value = "http://carts-db:8000" },
#         { name = "AWS_ACCESS_KEY_ID", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_ACCESS_KEY_ID" } } },
#         { name = "AWS_SECRET_ACCESS_KEY", valueFrom = { secretKeyRef = { name = "retail-db-secret", key = "AWS_SECRET_ACCESS_KEY" } } }
#       ]
#     })
#   ]
# }