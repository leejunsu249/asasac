locals {
  policy_json = data.aws_iam_policy_document.generic_endpoint_policy.json
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.7.1" 

  vpc_id = module.asasac_vpc.vpc_id

  create_security_group      = true
  security_group_name_prefix = "p-asasac-vpc-endpoints-sg"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.asasac_vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    s3 = {
      service             = "s3"
      service_type        = "Gateway"
      route_table_ids     = module.asasac_vpc.private_route_table_ids
      tags = { Name = "s3-vpc-endpoint-gateway" }
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = slice(module.asasac_vpc.private_subnets,6,7)
      policy              = local.policy_json

      tags = { Name = "ecr.a-vpc-endpoint" }
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = slice(module.asasac_vpc.private_subnets,6,7)
      policy              = local.policy_json
      tags = { Name = "ecr.d-vpc-endpoint" }
    }
  }

  tags ={
        "SupportPlatformOwnerPrimary"     = "Asasac"
        "System"	                      = "network"
  }
}