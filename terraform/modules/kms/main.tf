resource "aws_kms_key" "kms_key" {
  is_enabled = true
  
  description = "${var.project_name}-${terraform.workspace}-kms-key"

  key_usage = "ENCRYPT_DECRYPT"
 
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  deletion_window_in_days = 30

  enable_key_rotation = false
  
  tags = {
    Name = "${var.project_name}-${terraform.workspace}-kms-key"
  }
}
