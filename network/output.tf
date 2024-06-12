output "azs" {
  value = module.asasac_vpc.azs
}

output "vpc_id" {
  value = module.asasac_vpc.vpc_id
}

output "public_subnets" {
  value = module.asasac_vpc.public_subnets
}

output "private_subnets_app1" {
  value = slice(module.asasac_vpc.private_subnets,0,2)
}

output "private_subnets_app2" {
  value = slice(module.asasac_vpc.private_subnets,2,4)
}

output "private_subnets_app3" {
  value = slice(module.asasac_vpc.private_subnets,4,6)
}

output "private_subnets_ep" {
  value = slice(module.asasac_vpc.private_subnets,6,8)
}

output "private_routetables" {
  value = module.asasac_vpc.private_route_table_ids
}

output "database_subnets" {
  value = module.asasac_vpc.database_subnets
}