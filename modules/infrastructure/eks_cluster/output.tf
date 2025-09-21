output "eks_cluster_id" {
  description = "The ID of the EKS cluster."
  value       = aws_eks_cluster.retail_eks.id
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.retail_eks.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  value       = aws_eks_cluster.retail_eks.endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "The certificate authority data for the EKS cluster."
  value       = aws_eks_cluster.retail_eks.certificate_authority[0].data
  sensitive   = true
}

output "eks_node_group_id" {
  description = "The ID of the EKS node group."
  value       = aws_eks_node_group.retail_nodes.id
}

output "eks_node_group_arn" {
  description = "The ARN of the EKS node group."
  value       = aws_eks_node_group.retail_nodes.arn
}

output "eks_cluster_role_arn" {
  description = "The ARN of the EKS cluster IAM role."
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "The ARN of the EKS node group IAM role."
  value       = aws_iam_role.eks_node_role.arn
}

output "eks_cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster."
  value       = aws_eks_cluster.retail_eks.identity[0].oidc[0].issuer
}
