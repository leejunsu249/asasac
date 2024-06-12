resource "aws_alb" "ecs_cluster_alb" {
    name     = "${var.environment}-${var.service_name}-api-ALB"
    internal = false
    security_groups = [aws_security_group.ecs_alb_security_group.id, aws_security_group.lb_sg_management.id]
    subnets         = data.terraform_remote_state.network.outputs.public_subnets

    tags = { 
        Name = "${var.environment}-${var.service_name}-api-ALB"
        System                      = "ALB",
        SupportPlatformOwnerPrimary = "Asasac",
        OperationLevel              = "2"        
    }       
}

# resource "aws_alb_listener" "ecs_alb_https_lisener" {
#     load_balancer_arn = aws_alb.ecs_cluster_alb.arn
#     port              = 443
#     protocol          = "HTTPS"
#     ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" 
#     certificate_arn   = aws_acm_certificate.ecs_domain_certificate.arn
    
#     default_action {
#       type             = "forward"
#       target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
#     }

#     depends_on = [ aws_alb_target_group.ecs_default_target_group ]
  
# }

resource "aws_alb_listener" "ecs_alb_http_lisener" {
    load_balancer_arn = aws_alb.ecs_cluster_alb.arn
    port              = 80
    protocol          = "HTTP"
    
    default_action {
      type             = "forward"
      target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
    }

    depends_on = [ aws_alb_target_group.ecs_app_target_group ]
  
}

# resource "aws_alb_target_group" "ecs_default_target_group" {
#     name     = "${var.environment}-${var.service_name}-api-TG"
#     port     = 80
#     protocol = "HTTP"
#     vpc_id   = data.terraform_remote_state.network.outputs.vpc_id


#     tags = { 
#         Name = "${var.environment}-${var.service_name}-api-TG"
#         System                      = "ALB",
#         SupportPlatformOwnerPrimary = "Asasac",
#         OperationLevel              = "2"        
#     }    
  
# }