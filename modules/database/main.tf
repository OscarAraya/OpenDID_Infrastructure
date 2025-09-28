resource "aws_rds_cluster" "aurora_postgresql" {
  cluster_identifier      = "${var.name}-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = "07:00-09:00"
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  db_subnet_group_name    = var.private_data_subnet_group_name
  vpc_security_group_ids  = [var.aurora_sg_id]

  tags = {
    Name = "${var.name}-aurora-cluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  identifier          = "${var.name}-aurora-instance"
  cluster_identifier  = aws_rds_cluster.aurora_postgresql.id
  instance_class      = var.instance_class
  engine              = aws_rds_cluster.aurora_postgresql.engine
  engine_version      = aws_rds_cluster.aurora_postgresql.engine_version

  tags = {
    Name = "${var.name}-aurora-instance"
  }
}