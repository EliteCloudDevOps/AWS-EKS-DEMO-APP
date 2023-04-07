resource "aws_db_instance" "postgres_primary" {
    name = "${var.project_name}_${terraform.workspace}_postgres_primary"
    port = 5432
    identifier = "${var.project_name}-${terraform.workspace}-postgres-primary"

    publicly_accessible = false

    username = "postgres"
    password = var.postgres_password
    iam_database_authentication_enabled = true

    allocated_storage = 10 # 350GB
    max_allocated_storage = 20 # 1 TB
    storage_type = "gp2"
    storage_encrypted = false
    # kms_key_id = var.kms_key_arn

    engine = "postgres"
    engine_version = "12.5"
    instance_class = "db.t2.micro"

    auto_minor_version_upgrade = false
    allow_major_version_upgrade = false

    multi_az = true
    db_subnet_group_name = aws_db_subnet_group.postgres_primary.id
    # parameter_group_name = aws_db_parameter_group.postgres_parameter_group.id
    # option_group_name = aws_db_option_group.postgres_audit.id

    backup_retention_period = 7
    skip_final_snapshot = true

    maintenance_window              = "Mon:00:00-Mon:03:00"
    enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]    

    # performance_insights_enabled = true
    # performance_insights_retention_period = 14
    # performance_insights_kms_key_id = aws_kms_key.raffall.arn

    vpc_security_group_ids = [aws_security_group.postgres_primary.id]

    tags = {
        Name = "${var.project_name}-${terraform.workspace}-postgres-primary"
    }
}
