resource "aws_security_group" "ecs_alb_security_group" {
    name        = "${var.environment}-${var.service_name}-ALB-SG"
    vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
    description = "Security Group for ALB to traffic for ECS cluster"

    ingress {
        from_port   = 443
        protocol    = "TCP"
        to_port     = 443
        cidr_blocks = [var.front_cidr_blocks]
   }

    ingress {
        from_port   = 80
        protocol    = "TCP"
        to_port     = 80
        cidr_blocks = [var.front_cidr_blocks]
   }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.internet_cidr_blocks]
  }

  tags = {
    Name = "${var.environment}-${var.service_name}-ALB-SG",
    SupportPlatformOwnerPrimary = "Asasac",
    OperationLevel              = "2"
  }  

}

resource "aws_security_group" "lb_sg_management" {
  name        = "${var.environment}-${var.service_name}-ALB-SG-management"
  description = "Managed asasac api alb all traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Name = "${var.environment}-${var.service_name}-ALB-SG-management",
    SupportPlatformOwnerPrimary = "Asasac",
    OperationLevel              = "2"
  }
}