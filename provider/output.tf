output "aws_region" {
  description = "The AWS region in use."
  value       = var.region
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster used by the Kubernetes provider."
  value       = aws_eks_cluster.retail_eks.endpoint
}
