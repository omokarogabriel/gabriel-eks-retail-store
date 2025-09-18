output "redis_subnet_group_name" {
  description = "The name of the ElastiCache subnet group."
  value       = aws_elasticache_subnet_group.redis_subnet_group.name
}

output "redis_subnet_group_id" {
  description = "The ID of the ElastiCache subnet group."
  value       = aws_elasticache_subnet_group.redis_subnet_group.id
}

output "redis_cluster_id" {
  description = "The ID of the Redis cluster."
  value       = aws_elasticache_cluster.redis.id
}

output "redis_cluster_endpoint" {
  description = "The endpoint of the Redis cluster."
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_cluster_port" {
  description = "The port of the Redis cluster."
  value       = aws_elasticache_cluster.redis.port
}
