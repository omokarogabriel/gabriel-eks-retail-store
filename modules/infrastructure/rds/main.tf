##The RDS

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

# Data source to get RDS security group
data "aws_security_group" "rds_sg" {
  filter {
    name   = "group-name"
    values = ["${var.vpc_name}-rds-sg"]
  }
  vpc_id = data.aws_vpc.retail_vpc.id
}

# Data source to get PostgreSQL password from Secrets Manager
data "aws_secretsmanager_secret" "postgres_password" {
  name = "${var.vpc_name}-postgres-password"
}

data "aws_secretsmanager_secret_version" "postgres_password" {
  secret_id = data.aws_secretsmanager_secret.postgres_password.id
}

# Data source to get MySQL password from Secrets Manager
data "aws_secretsmanager_secret" "mysql_password" {
  name = "${var.vpc_name}-mysql-password"
}

data "aws_secretsmanager_secret_version" "mysql_password" {
  secret_id = data.aws_secretsmanager_secret.mysql_password.id
}

##The subnet group for all rds
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.rds_subnet_group_name
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "${var.vpc_name}-rds-subnet-group"
  }
}

##postgres rds instance
resource "aws_db_instance" "postgres" {
  identifier                              = "${var.vpc_name}-postgres-database"

  engine                                  = "postgres"
  engine_version                          = "15.3"
  instance_class                          = "db.t3.medium"

  allocated_storage                       = 20
  max_allocated_storage                   = 100
  storage_type                            = "gp2"
  storage_encrypted                       = true

  db_name                                 = "retail"
  username                                = var.postgres_username
  password                                = data.aws_secretsmanager_secret_version.postgres_password.secret_string
  iam_database_authentication_enabled    = true

  db_subnet_group_name                    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids                  = [data.aws_security_group.rds_sg.id]

  multi_az                                = true
  publicly_accessible                     = false
  skip_final_snapshot                     = true

  backup_retention_period                 = 7
  backup_window                           = "03:00-04:00"
  maintenance_window                      = "sun:04:00-sun:05:00"

  deletion_protection                     = false

  tags = {
    Name                                  = "${var.vpc_name}-rds-postgres-db"
  }
}



##The subnet group for all rds
# resource "aws_db_subnet_group" "rds_subnet_group" {
#   name = var.rds_subnet_group_name
#   subnet_ids = aws_subnet.private[*].id

#   tags = {
#     Name = "${var.vpc_name}-rds-subnet-group"
#   }
# }

# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier                               = "${var.vpc_name}-mysql-database"
  
  engine                                   = "mysql"
  engine_version                           = "8.0"
  instance_class                           = "db.t3.micro"
  
  allocated_storage                        = 20
  max_allocated_storage                    = 100
  storage_type                             = "gp2"
  storage_encrypted                        = true
  
  db_name                                  = "retail"
  username                                 = var.mysql_username
  password                                 = data.aws_secretsmanager_secret_version.mysql_password.secret_string
  iam_database_authentication_enabled     = true
  
  db_subnet_group_name                     = aws_db_subnet_group.rds_subnet_group.name
#   parameter_group_name   = aws_db_parameter_group.retail_db.name
  vpc_security_group_ids                   = [data.aws_security_group.rds_sg.id]

  multi_az                                 = true
  publicly_accessible                      = false
  skip_final_snapshot                      = true
  
  backup_retention_period                  = 7
  backup_window                            = "03:00-04:00"
  maintenance_window                       = "sun:04:00-sun:05:00"
  
  deletion_protection                      = false
  
  tags = {
    Name                                   = "${var.vpc_name}-rds-mysql-db"
    # Environment = var.environment
  }
}


