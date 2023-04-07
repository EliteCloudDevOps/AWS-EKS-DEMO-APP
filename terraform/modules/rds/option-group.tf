resource "aws_db_option_group" "postgres_audit" {
  name                     = "postgres-12-audit"
  option_group_description = "test option group to audit db activities "
  engine_name              = "postgres"
  major_engine_version     = "12"

  # option {
  #   option_name = "MARIADB_AUDIT_PLUGIN"
  #   option_settings {
  #     name = "SERVER_AUDIT_EVENTS"
  #     value = "CONNECT,QUERY_DCL"
  #   }

  # }
}

# resource "aws_db_parameter_group" "postgres_parameter_group" {
#   name   = "rds-pg"
#   family = "postgres11"

#   # parameter {
#   #   name  = "character_set_server"
#   #   value = "utf8"
#   # }

#   parameter {
#     name  = "character_set_client"
#     value = "utf8"
#   }
# }