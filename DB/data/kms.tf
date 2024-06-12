resource "aws_kms_key" "rds" {
  description             = "KMS key for rds"
  deletion_window_in_days = 7
  enable_key_rotation = true
  
  tags = {
    Name = "${var.environment}-asasac-kms-an2-rds",
    System                      = "DB",
    SupportPlatformOwnerPrimary = "Asasac",
    OperationLevel              = "3"
  }
}

resource "aws_kms_alias" "rds" {
    name = "alias/${var.environment}-asasac-kms-an2-rds"
    target_key_id = aws_kms_key.rds.key_id
}


resource "aws_kms_key" "redis" {
  description             = "KMS key for redis"
  deletion_window_in_days = 7
  enable_key_rotation = true

  tags = {
    Name = "${var.environment}-kms-${var.aws_shot_region}-redis",
    System                      = "Redis",
    SupportPlatformOwnerPrimary = "Asasac",
    OperationLevel              = "3"
  }
}

resource "aws_kms_alias" "redis" {
    name = "alias/${var.environment}-kms-${var.aws_shot_region}-redis"
    target_key_id = aws_kms_key.redis.key_id
}
