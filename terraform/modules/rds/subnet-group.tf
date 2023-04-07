resource "aws_db_subnet_group" "postgres_primary" {
  name       = "${var.project_name}-${terraform.workspace}-postgres-primary-subnet-group"
  subnet_ids = [var.stateful_private_subnet_a_id, var.stateful_private_subnet_b_id]

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-postgres-primary-subnet-group"
  }
}
