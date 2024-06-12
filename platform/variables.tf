variable "aws_shot_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "service_name" {
  type = string
}

variable "front_cidr_blocks" {
  type = string
}

variable "internet_cidr_blocks" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "docker_image_url" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "docker_container_port" {
  type = number
}

variable "spring_profile" {
  type = string
}

variable "region" {
  type = string
}

variable "desired_task_number" {
  type = string
}