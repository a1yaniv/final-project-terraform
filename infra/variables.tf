# All the input variables, with validation blocks
variable "region" {
  type        = string
  default     = "eu-north-1"
  description = "AWS region"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for all resource names (max 12 chars, lowercase, digits, hyphens)"

  validation {
    condition     = can(regex("^[a-z0-9-]{1,12}$", var.name_prefix))
    error_message = "name_prefix must be lowercase letters, digits, or hyphens, up to 12 characters."
  }
}

variable "env" {
  type        = string
  description = "Environment name (dev or prod)"

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "env must be either 'dev' or 'prod'."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "desired_count" {
  type        = number
  description = "Number of tasks per ECS service"
  default     = 1
}

variable "image_tag" {
  type        = string
  description = "Docker image tag to deploy"
}

variable "option_a" {
  type        = string
  default     = "ביבי"
  description = "First voting option"
}

variable "option_b" {
  type        = string
  default     = "אייזנקוט"
  description = "Second voting option"
}