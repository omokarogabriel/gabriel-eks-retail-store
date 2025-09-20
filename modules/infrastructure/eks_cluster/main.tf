###eks cluster and node group

# Data source to get EKS cluster IAM role
data "aws_iam_role" "eks_cluster_role" {
  name = "${var.vpc_name}-eks-cluster-role"
}

# Data source to get EKS node group IAM role
data "aws_iam_role" "eks_node_role" {
  name = "${var.vpc_name}-eks-node-role"
}

# Data source to get VPC
data "aws_vpc" "retail_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Data source to get subnets
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.retail_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-public-*"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.retail_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-private-*"]
  }
}

resource "aws_eks_cluster" "retail_eks" {
  name     = "${var.vpc_name}-eks-cluster"
  role_arn = data.aws_iam_role.eks_cluster_role.arn
  version  = "1.28"

  vpc_config {
    subnet_ids              = concat(data.aws_subnets.public.ids, data.aws_subnets.private.ids)
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["10.0.0.0/16"]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    data.aws_iam_role.eks_cluster_role
  ]

  tags = {
    Name = "${var.vpc_name}-eks-cluster"
  }
}

# EKS Node Group
resource "aws_eks_node_group" "retail_nodes" {
  cluster_name    = aws_eks_cluster.retail_eks.name
  node_group_name = "${var.vpc_name}-node-group"
  node_role_arn   = data.aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnets.private.ids

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }



  depends_on = [
    data.aws_iam_role.eks_node_role
  ]

  tags = {
    Name = "${var.vpc_name}-node-group"
  }
}