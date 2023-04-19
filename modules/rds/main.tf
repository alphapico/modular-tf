resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.app_name}-${var.env_prefix}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.app_name}-${var.env_prefix}-rds-subnet-group"
  }
}

resource "aws_db_instance" "charonium" {
  identifier        = "${var.env_prefix}-${var.db_name}"
  engine            = "postgres"
  engine_version    = "12"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp2"

  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  port                = var.postgres_port
  publicly_accessible = false

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = "${var.app_name}-${var.env_prefix}-rds"
  }
}
