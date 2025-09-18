###role and policy for eks cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.vpc_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


# EKS Node Group IAM Role
resource "aws_iam_role" "eks_node_role" {
  name = "${var.vpc_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.retail_eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.retail_eks.identity[0].oidc[0].issuer
}




#Create an IAM Role for a Service Account (Terraform)

# resource "aws_iam_role" "example_sa_role" {
#   name = "example-sa-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Federated = aws_iam_openid_connect_provider.eks_oidc.arn
#       }
#       Action = "sts:AssumeRoleWithWebIdentity"
#       Condition = {
#         StringEquals = {
#           "${replace(aws_iam_openid_connect_provider.eks_oidc.url, "https://", "")}:sub" = "system:serviceaccount:<namespace>:<service-account-name>"
#         }
#       }
#     }]
#   })
# }

resource "aws_iam_role" "sa_role" {
  name = "${var.sa_role_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks_oidc.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks_oidc.url, "https://", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
        }
      }
    }]
  })
}



# data "aws_iam_policy_document" "secret_manager_access" {
#   statement {
#     actions = [
#       "secretsmanager:GetSecretValue"
#     ]
#     resources = [
#       aws_secretsmanager_secret.mysql_password.arn, 
#       aws_secretsmanager_secret.postgres_password.arn
#     ]
#   }
# }

# resource "aws_iam_policy" "rds_eks_secrets_policy" {
#   name                                      = "rds-eks-secrets-access"
#   policy                                    = data.aws_iam_policy_document.secret_manager_access.json
# }

# resource "aws_iam_role_policy_attachment" "rds_eks_node_secrets_attach" {
#   role                                      = aws_iam_role.eks_node_role.name
#   policy_arn                                = aws_iam_policy.rds_eks_secrets_policy.arn
# }

# # resource "aws_iam_policy_attachment" "eks_node_ssm" {
# #   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# #   roles      = aws_iam_role.eks_node_role.name
# # }

# ###setting up iam role for service account IRSA
# data "aws_iam_policy_document" "assume_role_policy" {
#   statement {
#     effect                                  = "Allow"
#     principals {
#       type                                  = "Federated"
#       identifiers                           = [aws_eks_cluster.retail_eks.arn]
#     }

#     actions                                   = ["sts:AssumeRoleWithWEbIdentity"]

#     condition {
#       test                                    = "StringEquals"
#       variable                                = ""
#       values                                  = ""
#     }
#   }
# }


# #creating external secret role
# resource "aws_iam_role" "external_secrets_role" {
#   name                                        = "external-secrets-role"
#   assume_role_policy                          = data.aws_iam_policy_document.assume_role_policy.json
# }

# resource "aws_iam_role_policy" "external_secrets_policy" {
#   role                                        = aws_iam_role.external_secrets_role.id

#   policy = jsonencode({
#     Version                                   = "2012-10-17"
#     Statement                                 = [{
#       Effect                                  = "Allow",  
#       Action                                  = ["secretmanager:GetSecretValue"],
#       Resource                                = [aws_secretsmanager_secret.postgres_password.arn, 
#                                                  aws_secretsmanager_secret.mysql_password.arn]
#     }]
#   })
# }
