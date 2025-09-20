##The security group for the node group
##The security group for mySQL
##The security group for postGRES   
##The security group for redis
##The security group for dynamoDB

# Data source to get VPC
data "aws_vpc" "retail_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Additional Security Group for EKS Worker Nodes
resource "aws_security_group" "eks_nodes_sg" {
  name_prefix = "${var.vpc_name}-eks-nodes-"
  vpc_id      = data.aws_vpc.retail_vpc.id

  ingress {
    description = "Allow nodes to communicate with each other"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
  }

  ingress {
    description = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-eks-nodes-sg"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name_prefix = "${var.vpc_name}-rds-"
  vpc_id      = data.aws_vpc.retail_vpc.id

  ingress {
    description = "MySQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_nodes_sg.id]
  }

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_nodes_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-rds-sg"
  }
}

# Security Group for ElastiCache
resource "aws_security_group" "elasticache_sg" {
  name_prefix = "${var.vpc_name}-elasticache-"
  vpc_id      = data.aws_vpc.retail_vpc.id

  ingress {
    description = "Redis"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_nodes_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-elasticache-sg"
  }
}

# Security Group for ALB
# resource "aws_security_group" "alb_sg" {
#   name_prefix = "${var.vpc_name}-alb-"
#   vpc_id      = aws_vpc.retail_vpc.id

#   ingress {
#     description = "HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTPS"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.vpc_name}-alb-sg"
#   }
# }