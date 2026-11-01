# RDS: subnet group and instance, the generated password and its Secrets Manager secret
# Random password (D3)
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# Secrets Manager Secret (D3)
resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${local.name}-db-password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}

# Subnet Group over private subnets (N4)
resource "aws_db_subnet_group" "rds" {
  name       = "${local.name}-rds-subnet-group"
  subnet_ids = [for s in aws_subnet.private : s.id]

  tags = {
    Name = "${local.name}-rds-subnet-group"
  }
}

# RDS Postgres Instance (D2)
resource "aws_db_instance" "postgres" {
  identifier             = "${local.name}-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"
  db_name                = "votes"
  username               = "voteadmin"
  password               = random_password.db_password.result
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}