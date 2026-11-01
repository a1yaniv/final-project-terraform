# Task execution role, policy attachment, permission to read the secret
resource "aws_iam_role" "execution" {
  name = "${local.name}-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "execution_default" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "secret_access" {
  name        = "${local.name}-secret-access"
  description = "Allow reading only the DB password secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          aws_secretsmanager_secret.db_password.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "execution_secret" {
  role       = aws_iam_role.execution.name
  policy_arn = aws_iam_policy.secret_access.arn
}