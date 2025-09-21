# # Configure aws-auth ConfigMap to allow GitHub Actions role access
# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = var.eks_node_role_arn
#         username = "system:node:{{EC2PrivateDNSName}}"
#         groups = [
#           "system:bootstrappers",
#           "system:nodes"
#         ]
#       },
#       {
#         rolearn  = var.github_actions_role_arn
#         username = "github-actions"
#         groups = [
#           "system:masters"
#         ]
#       }
#     ])
#   }
# }