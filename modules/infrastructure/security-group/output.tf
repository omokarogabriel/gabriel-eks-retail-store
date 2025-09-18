output "eks_nodes_sg_id" {
  description = "The ID of the EKS nodes security group."
  value       = aws_security_group.eks_nodes_sg.id
}

output "rds_sg_id" {
  description = "The ID of the RDS security group."
  value       = aws_security_group.rds_sg.id
}

output "elasticache_sg_id" {
  description = "The ID of the ElastiCache security group."
  value       = aws_security_group.elasticache_sg.id
}
