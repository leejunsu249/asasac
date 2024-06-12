##### Default Configuration #####
aws_shot_region    = "an2"
environment        = "p"
service_name       = "asasac"


##### DB Configuration #####
mysql_clusters = {
  asasac-cluster = {
    name                     = "asasac",
    create_global_cluster    = false,
    resource_prefix          = "",
    instance_class           = "db.r6g.large",
    port                     = 3306,
    instance_count           = 2,
    master_username          = "asasac_master",
    apply_immediately        = true,
    skip_final_snapshot      = true,
    create_rds_proxy         = false,
    autoscaling_enabled      = true,
    autoscaling_min_capacity = 2,
    autoscaling_max_capacity = 5,
    predefined_metric_type   = "RDSReaderAverageCPUUtilization",
    autoscaling_target_cpu   = 70,
    tags = {
      System                      = "rds",
      SupportPlatformOwnerPrimary = "Asasac",
      OperationLevel              = "2"
    }
  }
}

##### redis.tf #####
redis_global_replication = false
auth_redis_node_type     = "cache.m6g.large"
session_redis_node_type  = "cache.m6g.large"
redis_multi_az           = true
cluster_mode             = true
parameter = [
  {
    name  = "notify-keyspace-events"
    value = "Ex"
  },
  {
    name  = "slowlog-log-slower-than"
    value = "2000"
  },
  {
    name  = "slowlog-max-len"
    value = "1024"
  }
]

redis_password_spacial = false
