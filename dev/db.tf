resource "aws_db_subnet_group" "db" {
  name        = "db_sg_${local.env}"
  description = "RDS subnet group"
  subnet_ids = [
    aws_subnet.private-1.id,
    aws_subnet.private-2.id,
    aws_subnet.private-3.id
  ]
}

resource "aws_db_parameter_group" "default" {
  name   = "db_pg_${local.env}"
  family = "mysql8.0"

  parameter {
    name         = "time_zone"
    value        = "America/Bogota"
    apply_method = "immediate"
  }
}

resource "aws_db_instance" "db" {
  identifier_prefix       = "db-${local.env}"
  engine                  = "mysql"
  allocated_storage       = 30
  instance_class          = "db.t3.micro"
  db_name                 = var.DB_NAME
  username                = var.DB_USER
  password                = var.DB_PASSWORD
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.db.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  availability_zone       = aws_subnet.private-1.availability_zone
  backup_retention_period = 30
  parameter_group_name    = aws_db_parameter_group.default.name
  engine_version          = "8.0.33"
}
