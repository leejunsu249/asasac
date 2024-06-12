resource "aws_ecs_cluster" "prod-fargate-cluster" {
    depends_on = [ aws_alb.ecs_cluster_alb ]
    name = "${var.environment}-${var.service_name}-api-Cluster"  
    tags = { 
        Name = "${var.environment}-${var.service_name}-Fargate-Cluster"
        System                      = "ECS",
        SupportPlatformOwnerPrimary = "Asasac",
        OperationLevel              = "1"        
    }      
}

resource "aws_ecs_task_definition" "springbootapp-task-definition" {
    container_definitions    = data.template_file.ecs_task_definition_template.rendered
    family                   = var.ecs_service_name
    cpu                      = var.cpu
    memory                   = var.memory
    requires_compatibilities = ["FARGATE"] #EC2 and FARGATE
    network_mode             = "awsvpc"
    execution_role_arn       = aws_iam_role.fargate_iam_role.arn
    task_role_arn            = aws_iam_role.fargate_iam_role.arn
}

resource "aws_alb_target_group" "ecs_app_target_group" {
  depends_on = [ aws_alb.ecs_cluster_alb ]
  name          = "${var.environment}-${var.service_name}-api-TG"
  port          = var.docker_container_port
  protocol      = "HTTP"
  vpc_id        = data.terraform_remote_state.network.outputs.vpc_id
  target_type   = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200" 
    interval            = 30
    timeout             = 10
    unhealthy_threshold = "2"
    healthy_threshold   = "2"
  }

  tags = { 
        Name = "${var.environment}-${var.service_name}-api-TG"
        System                      = "ECS",
        SupportPlatformOwnerPrimary = "Asasac",
        OperationLevel              = "1"        
  }  

}

resource "aws_ecs_service" "ecs_service" {
    depends_on = [ aws_alb.ecs_cluster_alb ]
    name            = var.ecs_service_name
    task_definition = var.ecs_service_name
    desired_count   = var.desired_task_number
    cluster         = aws_ecs_cluster.prod-fargate-cluster.name
    launch_type     = "FARGATE" 

    network_configuration {
      subnets          = data.terraform_remote_state.network.outputs.private_subnets_app1
      security_groups  = [aws_security_group.api_security_group.id, aws_security_group.api_managed_security_group.id] 
      assign_public_ip = false
    }

    load_balancer {
      container_name   = var.ecs_service_name
      container_port   = var.docker_container_port
      target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
    }
}

resource "aws_alb_listener_rule" "ecs_alb_listener_rule" {
    depends_on = [ aws_alb.ecs_cluster_alb ]    
    listener_arn = aws_alb_listener.ecs_alb_http_lisener.arn
    priority     = 100

    action {
      type             = "forward"
      target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
    }
    condition {
        host_header {
          values = ["p-asasac-api-ALB-1608812919.ap-northeast-2.elb.amazonaws.com"]
        }
    }
  
}


resource "aws_cloudwatch_log_group" "springbootapp_log_group" {
    # created by AWS itself
    name = "${var.ecs_service_name}-LogGroup"
}