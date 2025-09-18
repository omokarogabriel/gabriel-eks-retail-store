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
}

output "eks_node_group_id" {
  description = "The ID of the EKS node group."
  value       = aws_eks_node_group.retail_nodes.id
}

output "eks_node_group_arn" {
  description = "The ARN of the EKS node group."
  value       = aws_eks_node_group.retail_nodes.arn
}
