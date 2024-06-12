resource "aws_security_group" "api_security_group" {
    name        = "${var.ecs_service_name}-SG"
    description = "Security group for springbootapp to communicate in and out"
    vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

    tags = {
        Name = "${var.ecs_service_name}-SG",
        SupportPlatformOwnerPrimary = "Asasac",
        OperationLevel              = "2"
    }      
}

resource "aws_security_group" "api_managed_security_group" {
    name        = "${var.ecs_service_name}-SG-management"
    description = "Security group for springbootapp to communicate in and out"
    vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

    tags = {
        Name = "${var.ecs_service_name}-SG",
        SupportPlatformOwnerPrimary = "Asasac",
        OperationLevel              = "2"
    }            
}


resource "aws_security_group_rule" "allow_inbound_api" {
  description       = "allow inbound api traffic"
  from_port         = 8080
  protocol          = "tcp"
  to_port           = 8080
  type              = "ingress"
  security_group_id = aws_security_group.api_security_group.id
  source_security_group_id = aws_security_group.lb_sg_management.id
}

resource "aws_security_group_rule" "allow_outbound_api" {
  description                    = "allow_outbound_api"
  from_port                      = 0
  to_port                        = 0
  protocol                       = "-1"
  type                           = "egress"
  security_group_id              = aws_security_group.api_security_group.id
  cidr_blocks                    = ["0.0.0.0/0"]
  
}

