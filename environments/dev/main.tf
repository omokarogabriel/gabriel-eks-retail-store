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
  vpc_id   = module.networking.vpc_id
  cidr     = var.cidr
  
  depends_on = [module.networking]
}

# Create EKS cluster first (without OIDC dependencies)
module "eks_cluster" {
  source   = "../../modules/infrastructure/eks_cluster"
  vpc_name = var.vpc_name
  vpc_id   = module.networking.vpc_id
  
  depends_on = [
    module.networking,
    module.security_group
  ]
}

# Create IAM roles after EKS cluster exists
module "iam" {
  source               = "../../modules/infrastructure/iam"
  vpc_name             = var.vpc_name
  sa_role_name         = var.sa_role_name
  namespace            = var.namespace
  service_account_name = var.service_account_name
  
  depends_on = [module.eks_cluster]
}

module "rds" {
  source                = "../../modules/infrastructure/rds"
  rds_subnet_group_name = var.rds_subnet_group_name
  vpc_name              = var.vpc_name
  vpc_id                = module.networking.vpc_id
  postgres_username     = var.postgres_username
  mysql_username        = var.mysql_username
  rds_security_group_id = module.security_group.rds_sg_id

  depends_on = [
    module.networking,
    module.security_group,
    module.secrets
  ]
}

# Create secrets (AWS Secrets Manager only)
module "secrets" {
  source            = "../../modules/infrastructure/secrets"
  vpc_name          = var.vpc_name
  namespace         = var.namespace
  postgres_password = var.postgres_password
  mysql_password    = var.mysql_password
}

module "dynamodb" {
  source        = "../../modules/infrastructure/dynamoDB"
  dynamodb_name = var.dynamodb_name
  vpc_name      = var.vpc_name
}

module "elasticache" {
  source                     = "../../modules/infrastructure/elasticache"
  vpc_name                   = var.vpc_name
  vpc_id                     = module.networking.vpc_id
  redis_subnet_group_name    = var.redis_subnet_group_name
  elasticache_security_group_id = module.security_group.elasticache_sg_id
  
  depends_on = [
    module.networking,
    module.security_group
  ]
}

# EKS authentication will be handled in GitHub Actions workflow