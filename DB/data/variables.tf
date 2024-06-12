variable "aws_shot_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "service_name" {
  type = string
}

variable "mysql_clusters" {
  type = any
}

variable "redis_global_replication" {
  type = bool
}

variable "auth_redis_node_type" {
  type = string
}

variable "session_redis_node_type" {
  type = string
}

variable "redis_multi_az" {
  type = bool
}

variable "cluster_mode" {
  type = bool
}

variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
}

variable "redis_password_spacial" {
  type = bool
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
