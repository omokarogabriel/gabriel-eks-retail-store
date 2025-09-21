


resource "aws_secretsmanager_secret" "mysql_password" {
  name = "${var.vpc_name}-mysql-password"
  tags = {
    Name = "${var.vpc_name}-mysql-password"
  }
}

resource "aws_secretsmanager_secret_version" "mysql_password" {
  secret_id     = aws_secretsmanager_secret.mysql_password.id
  secret_string = var.mysql_password
}

resource "aws_secretsmanager_secret" "postgres_password" {
  name = "${var.vpc_name}-postgres-password"
  tags = {
    Name = "${var.vpc_name}-postgres-password"
  }
}

resource "aws_secretsmanager_secret_version" "postgres_password" {
  secret_id     = aws_secretsmanager_secret.postgres_password.id
  secret_string = var.postgres_password
}

# Kubernetes External Secrets will be created in application deployment phase
# These require the External Secrets Operator to be installed first

# resource "kubernetes_manifest" "external_secret_mysql" {
#   manifest = {
#     apiVersion = "external-secrets.io/v1beta1"
#     kind       = "ExternalSecret"
#     metadata = {
#       name      = "app-mysql-db-secret"
#       namespace = var.namespace
#     }
#     spec = {
#       refreshInterval = "1h"
#       secretStoreRef = {
#         name = "aws-secrets-store"
#         kind = "ClusterSecretStore"
#       }
#       target = {
#         name = "app-mysql-db-secret"
#       }
#       data = [{
#         secretKey = "db-creds.json"
#         remoteRef = { key = aws_secretsmanager_secret.mysql_password.name }
#       }]
#     }
#   }
# }

# resource "kubernetes_manifest" "external_secret_postgres" {
#   manifest = {
#     apiVersion = "external-secrets.io/v1beta1"
#     kind       = "ExternalSecret"
#     metadata = {
#       name      = "app-postgres-db-secret"
#       namespace = var.namespace
#     }
#     spec = {
#       refreshInterval = "1h"
#       secretStoreRef = {
#         name = "aws-secrets-store"
#         kind = "ClusterSecretStore"
#       }
#       target = {
#         name = "app-postgres-db-secret"
#       }
#       data = [{
#         secretKey = "db-creds.json"
#         remoteRef = { key = aws_secretsmanager_secret.postgres_password.name }
#       }]
#     }
#   }
# }
