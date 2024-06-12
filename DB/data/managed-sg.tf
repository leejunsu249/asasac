resource "aws_security_group" "management_rds_sg" {
  name        = "${var.environment}-asasac-management-rds-sg"
  description = "Allow rds management inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  tags = {
    Name = "${var.environment}-asasac-management-rds-s",
    System                      = "Rds",
    SupportPlatformOwnerPrimary = "Asasac",
    OperationLevel              = "3"
  }
}

resource "aws_security_group" "management_redis_sg" {
  name        = "${var.environment}-asasac-management-redis-sg"
  description = "Allow redis management inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  tags = {
    Name = "${var.environment}-asasac-management-redis-sg",
    System                      = "Redis",
    SupportPlatformOwnerPrimary = "Asasac",
    OperationLevel              = "3"
  }
}
