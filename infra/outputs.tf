# All the outputs
output "vote_url" {
  value       = "http://${aws_lb.main.dns_name}"
  description = "URL for vote application"
}

output "result_url" {
  value       = "http://${aws_lb.main.dns_name}:8080"
  description = "URL for result application"
}

output "redis_endpoint" {
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
  description = "Redis endpoint address"
}

output "db_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "PostgreSQL RDS endpoint"
}