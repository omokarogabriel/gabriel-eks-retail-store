output "eks_cluster_role_arn" {
  description = "The ARN of the EKS cluster IAM role."
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "The ARN of the EKS node group IAM role."
  value       = aws_iam_role.eks_node_role.arn
}

output "eks_cluster_policy_attachment_id" {
  description = "The ID of the EKS cluster policy attachment."
  value       = aws_iam_role_policy_attachment.eks_cluster_policy.id
}

output "eks_worker_node_policy_attachment_id" {
  description = "The ID of the EKS worker node policy attachment."
  value       = aws_iam_role_policy_attachment.eks_worker_node_policy.id
}

output "eks_cni_policy_attachment_id" {
  description = "The ID of the EKS CNI policy attachment."
  value       = aws_iam_role_policy_attachment.eks_cni_policy.id
}

output "eks_container_registry_policy_attachment_id" {
  description = "The ID of the EKS container registry policy attachment."
  value       = aws_iam_role_policy_attachment.eks_container_registry_policy.id
}

output "aws_load_balancer_controller_role_arn" {
  description = "The ARN of the AWS Load Balancer Controller IAM role."
  value       = aws_iam_role.aws_load_balancer_controller.arn
}

output "github_actions_role_arn" {
  description = "The ARN of the GitHub Actions IAM role."
  value       = aws_iam_role.github_actions.arn
}
