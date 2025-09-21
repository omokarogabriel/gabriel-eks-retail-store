# EKS cluster and node roles are now created in the EKS cluster module

output "aws_load_balancer_controller_role_arn" {
  description = "The ARN of the AWS Load Balancer Controller IAM role."
  value       = aws_iam_role.aws_load_balancer_controller.arn
}

output "github_actions_role_arn" {
  description = "The ARN of the GitHub Actions IAM role."
  value       = aws_iam_role.github_actions.arn
}
