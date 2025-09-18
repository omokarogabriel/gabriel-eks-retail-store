##rds for redis db

# Data source to get VPC
data "aws_vpc" "retail_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Data source to get private subnets
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

# Data source to get elasticache security group
data "aws_security_group" "elasticache_sg" {
  filter {
    name   = "group-name"
    values = ["${var.vpc_name}-elasticache-sg"]
  }
  vpc_id = data.aws_vpc.retail_vpc.id
}

##redis subnet group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = var.redis_subnet_group_name
  subnet_ids = data.aws_subnets.private.ids
}

##redis db instance
resource "aws_elasticache_cluster" "redis" {
  cluster_id                              = "retail-redis"
  engine                                  = "redis"
  node_type                               = "cache.t3.micro"
  num_cache_nodes                         = 1
  subnet_group_name                       = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids                      = [data.aws_security_group.elasticache_sg.id]
  port                                    = 6379


  tags = {
    Name                                 = "${var.vpc_name}-redis-db"
  }
}