# OIDC and Service Account IAM roles (created after EKS cluster exists)

# Get EKS cluster data
data "aws_eks_cluster" "retail_eks" {
  name = "${var.vpc_name}-eks-cluster"
}

# EKS OIDC Provider
data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.retail_eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.retail_eks.identity[0].oidc[0].issuer
  
  tags = {
    Name = "${var.vpc_name}-eks-oidc"
  }
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

# IAM Role for AWS Load Balancer Controller
resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "${var.vpc_name}-aws-load-balancer-controller"
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
          "${replace(aws_iam_openid_connect_provider.eks_oidc.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

# IAM Policy for AWS Load Balancer Controller
resource "aws_iam_policy" "aws_load_balancer_controller" {
  name = "${var.vpc_name}-AWSLoadBalancerControllerIAMPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:CreateServiceLinkedRole",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeTags",
          "ec2:GetCoipPoolUsage",
          "ec2:DescribeCoipPools",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeListenerCertificates",
          "elasticloadbalancing:DescribeSSLPolicies",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeTags"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cognito-idp:DescribeUserPoolClient",
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "iam:ListServerCertificates",
          "iam:GetServerCertificate",
          "waf-regional:GetWebACL",
          "waf-regional:GetWebACLForResource",
          "waf-regional:AssociateWebACL",
          "waf-regional:DisassociateWebACL",
          "wafv2:GetWebACL",
          "wafv2:GetWebACLForResource",
          "wafv2:AssociateWebACL",
          "wafv2:DisassociateWebACL",
          "shield:DescribeProtection",
          "shield:GetSubscriptionState",
          "shield:DescribeSubscription",
          "shield:CreateProtection",
          "shield:DeleteProtection"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags"
        ]
        Resource = "arn:aws:ec2:*:*:security-group/*"
        Condition = {
          StringEquals = {
            "ec2:CreateAction" = "CreateSecurityGroup"
          }
          Null = {
            "aws:RequestedRegion" = "false"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateTargetGroup"
        ]
        Resource = "*"
        Condition = {
          Null = {
            "aws:RequestedRegion" = "false"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:DeleteRule"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags"
        ]
        Resource = [
          "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
        ]
        Condition = {
          Null = {
            "aws:RequestedRegion" = "false"
            "aws:ResourceTag/elbv2.k8s.aws/cluster" = "false"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:SetIpAddressType",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetSubnets",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:DeleteTargetGroup"
        ]
        Resource = "*"
        Condition = {
          Null = {
            "aws:ResourceTag/elbv2.k8s.aws/cluster" = "false"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ]
        Resource = "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateTags"
        ]
        Resource = "arn:aws:ec2:*:*:security-group/*"
        Condition = {
          Null = {
            "aws:ResourceTag/elbv2.k8s.aws/cluster" = "false"
            "aws:RequestedRegion" = "false"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DeleteSecurityGroup"
        ]
        Resource = "*"
        Condition = {
          Null = {
            "aws:ResourceTag/elbv2.k8s.aws/cluster" = "false"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags"
        ]
        Resource = [
          "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
          "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
        ]
      }
    ]
  })
}

# Attach policy to AWS Load Balancer Controller role
resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
  role       = aws_iam_role.aws_load_balancer_controller.name
}

# GitHub Actions OIDC Provider
resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}

# GitHub Actions IAM Role
resource "aws_iam_role" "github_actions" {
  name = "${var.vpc_name}-github-actions-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github_actions.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:omokarogabriel/gabriel_retail_store:*"
        }
      }
    }]
  })
}

# GitHub Actions IAM Policy
resource "aws_iam_policy" "github_actions" {
  name = "${var.vpc_name}-github-actions-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "eks:*",
          "rds:*",
          "dynamodb:*",
          "elasticache:*",
          "secretsmanager:*",
          "iam:*",
          "sts:*",
          "elasticloadbalancing:*",
          "route53:*",
          "acm:*",
          "logs:*",
          "cloudformation:*",
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to GitHub Actions role
resource "aws_iam_role_policy_attachment" "github_actions" {
  policy_arn = aws_iam_policy.github_actions.arn
  role       = aws_iam_role.github_actions.name
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
