module "networking" {
  source              = "../../modules/infrastructure/networking"
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment         = var.environment
  vpc_name            = var.vpc_name
  cidr                = var.cidr
}

module "security_group" {
  source   = "../../modules/infrastructure/security-group"
  vpc_name = var.vpc_name
  cidr     = var.cidr
}

module "iam" {
  source               = "../../modules/infrastructure/iam"
  vpc_name             = var.vpc_name
  sa_role_name         = var.sa_role_name
  namespace            = var.namespace
  service_account_name = var.service_account_name
}

module "eks_cluster" {
  source   = "../../modules/infrastructure/eks_cluster"
  vpc_name = var.vpc_name
  
  depends_on = [
    module.networking,
    module.security_group
  ]
}

module "rds" {
  source                 = "../../modules/infrastructure/rds"
  rds_subnet_group_name  = var.rds_subnet_group_name
  vpc_name               = var.vpc_name
  postgres_username      = var.postgres_username
  mysql_username         = var.mysql_username
  postgres_password      = var.postgres_password
  mysql_password         = var.mysql_password

  depends_on = [
    module.networking,
    module.security_group,
    module.secrets
  ]
}

module "dynamodb" {
  source        = "../../modules/infrastructure/dynamoDB"
  dynamodb_name = var.dynamodb_name
  vpc_name      = var.vpc_name
}

module "elasticache" {
  source                  = "../../modules/infrastructure/elasticache"
  vpc_name                = var.vpc_name
  redis_subnet_group_name = var.redis_subnet_group_name
  
  depends_on = [
    module.networking,
    module.security_group
  ]
}
module "secrets" {
  source            = "../../modules/infrastructure/secrets"
  vpc_name          = var.vpc_name
  namespace         = var.namespace
  postgres_password = var.postgres_password
  mysql_password    = var.mysql_password
}
module "ingress_alb" {
  source   = "../../modules/infrastructure/ingress_alb"
#   vpc_name = var.vpc_name
  
  depends_on = [
    module.networking,
    module.eks_cluster
  ]
}
module "namespace_helm_release" {
  source    = "../../modules/infrastructure/namespace_helm_release"
  namespace = var.namespace
  vpc_name  = var.vpc_name

  depends_on = [
    module.networking,
    module.security_group
  ]
}
module "retail_app" {
  source = "../../modules/application/retail_app"
  
  depends_on = [
    module.eks_cluster,
    module.rds,
    module.dynamodb,
    module.elasticache,
    module.secrets
  ]
}

module "monitoring_logging" {
  source = "../../modules/application/monitoring_logging"
  
  depends_on = [
    module.eks_cluster,
    module.namespace_helm_release
  ]
}