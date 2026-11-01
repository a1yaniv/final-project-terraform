# Resources of one service: log group, task definition, ECS service
resource "aws_cloudwatch_log_group" "service" {
  name              = "/ecs/${var.name}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "service" {
  family                   = var.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.name
      image     = var.container_image
      essential = true

      portMappings = var.container_port != null ? [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ] : []

      environment = [
        for k, v in var.environment : {
          name  = k
          value = v
        }
      ]

      secrets = [
        for k, v in var.secrets : {
          name      = k
          valueFrom = v
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.service.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

data "aws_region" "current" {}

resource "aws_ecs_service" "service" {
  name                   = var.name
  cluster                = var.cluster_id
  task_definition        = aws_ecs_task_definition.service.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn != null ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.name
      container_port   = var.container_port
    }
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  wait_for_steady_state = true
}