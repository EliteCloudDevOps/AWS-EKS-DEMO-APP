resource "aws_security_group" "postgres_primary" {
  name        = "${var.project_name}-${terraform.workspace}-postgres-primary-sg"
  description = "Allows access with this security group."
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.project_name}-${terraform.workspace}-postgres-primary-sg"
  }
}

resource "aws_security_group_rule" "development_postgres_primary_ingress_sg_rule" {
  type              = "ingress"
  description       = "Allow traffic from VPC"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.postgres_primary.id
}
resource "aws_security_group" "postgres_replica" {
  name        = "${var.project_name}-${terraform.workspace}-postgres-replica-sg"
  description = "Allows access with this security group."
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.project_name}-${terraform.workspace}-postgres-replica-sg"
  }
}
resource "aws_security_group_rule" "development_postgres_replica_ingress_sg_rule" {
  type              = "ingress"
  description       = "Allow traffic from VPC"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.postgres_replica.id
}

