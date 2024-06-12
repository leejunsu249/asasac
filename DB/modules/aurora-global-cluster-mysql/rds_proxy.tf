resource "aws_db_proxy" "rds_proxy" {
  count = var.create_rds_proxy ? 1:0

	name                   = var.service_name_lv2
	debug_logging          = false
	engine_family          = "MYSQL"
	idle_client_timeout    = 1800
	require_tls            = false
	role_arn               = aws_iam_role.rds_proxy_role[0].arn
	vpc_security_group_ids = [aws_security_group.aurora_sg.id]
	vpc_subnet_ids         = var.db_subnets

	dynamic "auth" {
		for_each = var.db_users

		content {
			auth_scheme = "SECRETS"
			description = "value from secret manager"
			iam_auth    = "DISABLED"
			secret_arn  = auth.value
		}
	}

	tags = {
		Name = "rds-proxy-${var.aws_shot_region}-${var.environment}-${var.service_name}-${var.service_name_lv2}"
	}

  depends_on = [module.aurora_primary]
}

resource "aws_db_proxy_default_target_group" "rds_proxy" {
  count = var.create_rds_proxy ? 1:0

  db_proxy_name = aws_db_proxy.rds_proxy[0].name

  connection_pool_config {
    max_connections_percent      = 100
  }
}

resource "aws_db_proxy_endpoint" "rds_proxy_readonly" {
  count = var.create_rds_proxy ? 1:0

  db_proxy_name          = aws_db_proxy.rds_proxy[0].name
  db_proxy_endpoint_name = var.service_name_lv2
  vpc_subnet_ids         = var.db_subnets
	vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  target_role            = "READ_ONLY"
}

resource "aws_db_proxy_target" "rds_proxy" {
  count = var.create_rds_proxy ? 1:0

  db_cluster_identifier  = module.aurora_primary.cluster_id
  db_proxy_name          = aws_db_proxy.rds_proxy[0].name
  target_group_name      = aws_db_proxy_default_target_group.rds_proxy[0].name
}

##### Endpoint #####
resource "aws_ssm_parameter" "rds_proxy_endpoint" {
  count = var.create_rds_proxy ? 1:0

  name  = "pm-${var.aws_shot_region}-${var.environment}-${var.service_name}-${var.service_name_lv2}-proxy-endpoint"
  type  = "SecureString"
  value = jsonencode({
    "writer-endpoint": "${aws_db_proxy.rds_proxy[0].endpoint}",
    "reader-endpoint": "${aws_db_proxy_endpoint.rds_proxy_readonly[0].endpoint}"
  })
}

resource "aws_security_group_rule" "allow_proxy_inbound_rule" {
  count = var.create_rds_proxy ? 1:0

  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  self              = true
  description       = "3306 from rds proxy(self)"

  security_group_id = aws_security_group.aurora_sg.id
}

resource "aws_security_group_rule" "allow_proxy_outbound_rule" {
  count = var.create_rds_proxy ? 1:0

  type              = "egress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  self              = true
  description       = "3306 from rds proxy(self)"

  security_group_id = aws_security_group.aurora_sg.id
}

resource "aws_iam_role" "rds_proxy_role" {
  count = var.create_rds_proxy ? 1:0

  name = "${var.service_name_lv2}-rds-proxy-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "rds.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "iamr-${var.environment}-${var.service_name_lv2}-rds-proxy"
  }
}

resource "aws_iam_policy" "rds_proxy_policy" {
  count = var.create_rds_proxy ? 1:0

  name = "${var.service_name_lv2}-rds-proxy-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"]
        Effect   = "Allow"
        Resource = var.db_users
      },
    ]
  })

  tags = {
    Name = "iamp-${var.environment}-${var.service_name_lv2}-rds-proxy"
  }
}

resource "aws_iam_role_policy_attachment" "rds_proxy_policy_attachment" {
  count = var.create_rds_proxy ? 1:0

  role       = aws_iam_role.rds_proxy_role[0].name
  policy_arn = aws_iam_policy.rds_proxy_policy[0].arn
}