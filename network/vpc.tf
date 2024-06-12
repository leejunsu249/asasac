locals {
  vpc_cidr = "10.200.0.0/16"
  azs      = data.aws_availability_zones.available.names
  private_s1 = [for k, v in local.azs  : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  private_s2 = [for k, v in local.azs  : cidrsubnet(local.vpc_cidr, 8, k + 8)]
  private_s3 = [for k, v in local.azs  : cidrsubnet(local.vpc_cidr, 8, k + 12)]
  private_ep = [for k, v in local.azs  : cidrsubnet(local.vpc_cidr, 8, k + 16)]
}


module asasac_vpc {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.7.1"
    name = "p-asasac-vpc-an2"
    cidr = local.vpc_cidr
    azs = data.aws_availability_zones.available.names
    map_public_ip_on_launch = true

    #sunbnet  설정
    public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]    
    private_subnets     = concat(local.private_s1,local.private_s2, local.private_s3, local.private_ep)
    database_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 20)]

    private_subnet_names = ["p-asasac-sbn-pri1-an2", "p-asasac-sbn-pri2-an2", "p-asasac-sbn-pri3-an2", "p-asasac-sbn-pri4-an2",  "p-asasac-sbn-ep1-an2", "p-asasac-sbn-ep2-an2"]

    database_subnet_names    = ["p-asasac-sbn-an2-db1","p-asasac-sbn-an2-db2"]

    # nat 설정
    enable_nat_gateway = true
    single_nat_gateway = true

    tags = {
        "SupportPlatformOwnerPrimary"     = "Asasac"
        "System"	                      = "network"
    }

}

