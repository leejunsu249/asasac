variable "resource_prefix" {
  type    = string
  default = ""
}

variable "create_global_cluster" {
  type = bool
}

variable "global_cluster_identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_name_lv2" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "port" {
  type = string
}

variable "instance_count" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "master_username" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "apply_immediately" {
  type = string
}

variable "skip_final_snapshot" {
  type = string
}

variable "db_parameter_group_name" {
  type = string
}

variable "db_cluster_parameter_group_name" {
  type = string
}

variable "secet_manager_name" {
  type = string
}

variable "aws_shot_region" {
  type = string
}

variable "environment" {
  type = string
}

# variable "cluster_node_sg_id" {
#   type = string
# }

# variable "batch_cidr_blocks" {
#   type = list(any)
# }

##### rds_proxy #####
variable "create_rds_proxy" {
  type    = bool
  default = false
}

variable "db_subnets" {
  type    = list(any)
  default = []
}

variable "db_users" {
  type    = list(any)
  default = []
}

variable "autoscaling_enabled" {
  type    = bool
  default = false
}

variable "autoscaling_min_capacity" {
  type    = number
  default = null
}

variable "autoscaling_max_capacity" {
  type    = number
  default = null
}

variable "predefined_metric_type" {
  type    = string
  default = null
}

variable "autoscaling_target_cpu" {
  type    = number
  default = null
}

variable "autoscaling_target_connections" {
  type    = number
  default = null
}

variable "additional_sg" {
  type = list(any)
}

variable "additionanl_sg_rules" {
  type = any
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}