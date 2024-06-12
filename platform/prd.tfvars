##### Default Configuration #####
aws_shot_region    = "an2"
environment        = "p"
service_name       = "asasac"
region             = "ap-northeast-2"

front_cidr_blocks         = "0.0.0.0/0"
internet_cidr_blocks      = "0.0.0.0/0"

ecs_service_name    = "p-asasac-api"
docker_image_url    = "wnstn385/nginx:v1"

cpu                   = 1024
memory                = 2048
docker_container_port = 80
desired_task_number   = "2"
spring_profile        = "default"

