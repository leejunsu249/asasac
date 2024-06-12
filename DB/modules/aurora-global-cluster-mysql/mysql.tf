locals {
  global_cluster_identifier = var.resource_prefix != "" ? join(var.global_cluster_identifier, "-${var.resource_prefix}") : var.global_cluster_identifier
  name                      = var.resource_prefix != "" ? join(var.name, "-${var.resource_prefix}") : var.name
  secet_manager_name        = var.resource_prefix != "" ? join(var.secet_manager_name, "-${var.resource_prefix}_pw") : var.secet_manager_name
  tags = {
    Name   = local.global_cluster_identifier,
    Backup = "False"
  }
}

resource "aws_rds_global_cluster" "rds_aurora" {
  count = var.create_global_cluster ? 1 : 0

  global_cluster_identifier = local.global_cluster_identifier
  engine                    = var.engine
  engine_version            = var.engine_version
  storage_encrypted         = true
  deletion_protection       = true
}

module "aurora_primary" {
  source = "terraform-aws-modules/rds-aurora/aws"

  version = "6.2.0"

  name = var.name

  global_cluster_identifier = var.create_global_cluster ? aws_rds_global_cluster.rds_aurora[0].id : null

  engine         = var.engine
  engine_version = var.engine_version

  instance_class = var.instance_class
  port           = var.port
  instances      = { for i in range(var.instance_count) : i => {} }
  kms_key_id     = var.kms_key_id

  master_username        = var.master_username
  create_random_password = true

  publicly_accessible = false

  create_db_subnet_group = false
  create_security_group  = false

  vpc_id               = var.vpc_id
  db_subnet_group_name = var.db_subnet_group_name

  apply_immediately      = var.apply_immediately
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = concat([aws_security_group.aurora_sg.id], var.additional_sg)
  db_parameter_group_name         = var.db_parameter_group_name
  db_cluster_parameter_group_name = var.db_cluster_parameter_group_name

  deletion_protection     = true
  backup_retention_period = 7

  auto_minor_version_upgrade = false

  autoscaling_enabled            = var.autoscaling_enabled
  autoscaling_min_capacity       = var.autoscaling_enabled ? var.autoscaling_min_capacity : null
  autoscaling_max_capacity       = var.autoscaling_enabled ? var.autoscaling_max_capacity : null
  predefined_metric_type         = var.autoscaling_enabled ? var.predefined_metric_type : null
  autoscaling_target_cpu         = var.autoscaling_enabled && var.predefined_metric_type == "RDSReaderAverageCPUUtilization" ? var.autoscaling_target_cpu : null
  autoscaling_target_connections = var.autoscaling_enabled && var.predefined_metric_type != "RDSReaderAverageCPUUtilization" ? var.autoscaling_target_connections : null

  tags =  merge(local.tags, var.tags)

  enabled_cloudwatch_logs_exports = ["slowquery", "general"]
}

##### Endpoint #####
resource "aws_ssm_parameter" "mysql_endpoint" {
  name = "${var.name}-endpoint"
  type = "SecureString"
  value = jsonencode({
    "writer-endpoint" : "${module.aurora_primary.cluster_endpoint}",
    "reader-endpoint" : "${module.aurora_primary.cluster_reader_endpoint}"
  })
}

##### Root Password #####
resource "aws_secretsmanager_secret" "mysql_credentials" {
  name = var.secet_manager_name
}

resource "aws_secretsmanager_secret_version" "mysql_credentials" {
  secret_id     = aws_secretsmanager_secret.mysql_credentials.id
  secret_string = module.aurora_primary.cluster_master_password
}

##### Security Group #####
resource "aws_security_group" "aurora_sg" {
  name        = "rds-aurora-${var.service_name}-${var.service_name_lv2}-sg"
  vpc_id      = var.vpc_id
  description = "Control traffic to/from RDS Aurora rds-${var.aws_shot_region}-${var.environment}-${var.service_name}-${var.service_name_lv2}"

  tags = {
    Name = "sg-${var.aws_shot_region}-${var.environment}-${var.service_name}-${var.service_name_lv2}"
  }
}

# resource "aws_security_group_rule" "allow_ecs_inbound_aurora" {
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   source_security_group_id = var.cluster_node_sg_id
#   description              = "3306 from ecs"

#   security_group_id = aws_security_group.aurora_sg.id
# }

# resource "aws_security_group_rule" "allow_batch_inbound_aurora" {
#   type        = "ingress"
#   from_port   = 3306
#   to_port     = 3306
#   protocol    = "tcp"
#   cidr_blocks = var.batch_cidr_blocks
#   description = "3306 from batch"

#   security_group_id = aws_security_group.aurora_sg.id
# }


resource "aws_security_group_rule" "allow_inbound_aurora" {
  for_each = var.additionanl_sg_rules

  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"

  source_security_group_id = try(each.value.source_security_group_id, null)
  cidr_blocks = try(each.value.cidr_blocks, null)

  description = each.value.description

  security_group_id = aws_security_group.aurora_sg.id
}
