# ECS cluster, environment variables and secrets of the services, the three calls to the service module
resource "aws_ecs_cluster" "main" {
  name = "${local.name}-cluster"
}

module "vote_service" {
  source = "./modules/service"

  name               = "${local.name}-vote"
  cluster_id         = aws_ecs_cluster.main.id
  execution_role_arn = aws_iam_role.execution.arn
  container_image    = "${data.aws_ecr_repository.vote.repository_url}:${var.image_tag}"
  container_port     = 80
  desired_count      = var.desired_count
  subnets            = [for s in aws_subnet.public : s.id]
  security_groups    = [aws_security_group.ecs.id]
  target_group_arn   = aws_lb_target_group.vote.arn

  environment = {
    REDIS_HOST = aws_elasticache_cluster.redis.cache_nodes[0].address
    OPTION_A   = var.option_a
    OPTION_B   = var.option_b
  }
}

module "result_service" {
  source = "./modules/service"

  name               = "${local.name}-result"
  cluster_id         = aws_ecs_cluster.main.id
  execution_role_arn = aws_iam_role.execution.arn
  container_image    = "${data.aws_ecr_repository.result.repository_url}:${var.image_tag}"
  container_port     = 80
  desired_count      = var.desired_count
  subnets            = [for s in aws_subnet.public : s.id]
  security_groups    = [aws_security_group.ecs.id]
  target_group_arn   = aws_lb_target_group.result.arn

  environment = {
    DB_HOST = aws_db_instance.postgres.address
    DB_PORT = "5432"
    DB_USER = aws_db_instance.postgres.username
    DB_NAME = aws_db_instance.postgres.db_name
    DB_SSL  = "true"
  }

  secrets = {
    DB_PASSWORD = aws_secretsmanager_secret.db_password.arn
  }
}

module "worker_service" {
  source = "./modules/service"

  name               = "${local.name}-worker"
  cluster_id         = aws_ecs_cluster.main.id
  execution_role_arn = aws_iam_role.execution.arn
  container_image    = "${data.aws_ecr_repository.worker.repository_url}:${var.image_tag}"
  desired_count      = var.desired_count
  subnets            = [for s in aws_subnet.public : s.id]
  security_groups    = [aws_security_group.ecs.id]

  environment = {
    REDIS_HOST = aws_elasticache_cluster.redis.cache_nodes[0].address
    DB_HOST    = aws_db_instance.postgres.address
    DB_PORT    = "5432"
    DB_USER    = aws_db_instance.postgres.username
    DB_NAME    = aws_db_instance.postgres.db_name
    DB_SSL     = "true"
  }

  secrets = {
    DB_PASSWORD = aws_secretsmanager_secret.db_password.arn
  }
}