



terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.37.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "aws" {
}

provider "kubernetes" {
  host                   = aws_eks_cluster.retail_eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.retail_eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "kubernetes" {
  alias = "cluster"

  host                   = aws_eks_cluster.retail_eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.retail_eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "kubectl" {
  apply_retry_count      = 10
  host                   = aws_eks_cluster.retail_eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.retail_eks.cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.retail_eks.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(aws_eks_cluster.retail_eks.cluster_certificate_authority_data)
  }
}



#Terraform Kubernetes Provider
resource "kubernetes_service_account" "eks" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.sa_role.arn
    }
  }
}