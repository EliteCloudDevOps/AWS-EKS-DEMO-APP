locals {
  project_name = var.project_name
}

resource "aws_secretsmanager_secret" "development" {
  name = "${var.project_name}/secrets"
  description = "Secrets for ${var.project_name} development envrionment"
  kms_key_id = var.kms_key_arn

  tags = {
    env = "${terraform.workspace}"
    project = "${var.project_name}"
  }
}