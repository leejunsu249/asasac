resource "aws_elasticache_replication_group" "session_service_primary" {
  replication_group_id          =  "${var.environment}-${var.service_name}-redis-primary"
  description = "session-service replication group"

  engine         = "redis"
  engine_version = "7.1"
  node_type      = var.session_redis_node_type
  port           = 6379

  multi_az_enabled = var.redis_multi_az
  automatic_failover_enabled = var.redis_multi_az

  replicas_per_node_group = var.cluster_mode ? 1 : null #Replicas per Shard
  num_node_groups         = var.cluster_mode ? 1 : null #Replicas per Shar

  num_cache_clusters =  var.cluster_mode ? null : 1

  subnet_group_name = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids = [aws_security_group.session_service_redis_sg.id]

  kms_key_id = aws_kms_key.redis.arn
  at_rest_encryption_enabled = false
  transit_encryption_enabled = true

  parameter_group_name  = aws_elasticache_parameter_group.redis_session_service_param.name
  auto_minor_version_upgrade = false

  tags = {
    Name = "${var.environment}-${var.service_name}-rd-${var.aws_shot_region}-primary-session-service",
    System                      = "Redis",
    SupportPlatformOwnerPrimary = "Asasac",
    OperationLevel              = "3"
  }
}

resource "aws_security_group" "session_service_redis_sg" {
  name        = "${var.environment}-session-service-redis-sg"
  description = "Redis access"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Name = "${var.environment}-session-service-redis-sg",
    System                      = "Redis",
    SupportPlatformOwnerPrimary = "Asasac",
    OperationLevel              = "3"
  }
}

resource "aws_security_group_rule" "allow_ecsinbound_session_redis" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = data.terraform_remote_state.platform.outputs.api_managed_security_group_id
  description       = "6379 from ecs"

  security_group_id = aws_security_group.session_service_redis_sg.id
}

resource "aws_elasticache_parameter_group" "redis_session_service_param" {
  name   = "rcp-${var.aws_shot_region}-${var.environment}-${var.service_name}-session-service"
  family = "redis7"

  dynamic "parameter" {
    for_each = var.cluster_mode ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter

    content {
      name  = parameter.value.name
      value = tostring(parameter.value.value)
    }
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.environment}-${var.service_name}-rsg-${var.aws_shot_region}"
  subnet_ids = data.terraform_remote_state.network.outputs.database_subnets
}