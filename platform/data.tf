data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "p-terraform-asasac-an2"
    key    = "asasac/net.tfstate"
    region = "ap-northeast-2"
  }
}

data "template_file" "ecs_task_definition_template" {
    template = "${file("./task/task_definition.json")}"

    vars ={
        task_definition_name    = var.ecs_service_name
        ecs_service_name        = var.ecs_service_name
        docker_image_url        = var.docker_image_url
        memory                  = var.memory
        docker_container_port   = var.docker_container_port
        spring_profile          = var.spring_profile
        region                  = var.region  
    }
}