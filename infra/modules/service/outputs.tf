# Outputs of the service module
output "service_name" {
  value       = aws_ecs_service.service.name
  description = "ECS service name"
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.service.name
  description = "CloudWatch log group name"
}