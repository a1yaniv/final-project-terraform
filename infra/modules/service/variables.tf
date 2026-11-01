# Inputs of the service module
variable "name" {
  type        = string
  description = "Service name"
}

variable "cluster_id" {
  type        = string
  description = "ECS cluster ID"
}

variable "execution_role_arn" {
  type        = string
  description = "Task execution role ARN"
}

variable "cpu" {
  type        = string
  default     = "256"
  description = "CPU units"
}

variable "memory" {
  type        = string
  default     = "512"
  description = "Memory size in MB"
}

variable "container_image" {
  type        = string
  description = "Container image URI"
}

variable "container_port" {
  type        = number
  default     = null
  description = "Container port (optional)"
}

variable "desired_count" {
  type        = number
  default     = 1
  description = "Desired number of tasks"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs for task placement"
}

variable "security_groups" {
  type        = list(string)
  description = "Security group IDs"
}

variable "target_group_arn" {
  type        = string
  default     = null
  description = "Target group ARN for ALB integration (optional)"
}

variable "environment" {
  type        = map(string)
  default     = {}
  description = "Container environment variables"
}

variable "secrets" {
  type        = map(string)
  default     = {}
  description = "Container secrets"
}