output "cluster_master_password" {
  value = module.aurora_primary.cluster_master_password
}

output "cluster_reader_endpoint" {
  value = module.aurora_primary.cluster_reader_endpoint
}

output "cluster_writer_endpoint" {
  value = module.aurora_primary.cluster_endpoint
}

output "cluster_identifier" {
  value = module.aurora_primary.cluster_id	
}

output "security_group_id" {
  value = aws_security_group.aurora_sg.id
}
