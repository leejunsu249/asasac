data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "p-terraform-asasac-an2"
    key    = "asasac/net.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "platform" {
  backend = "s3"
  config = {
    bucket = "p-terraform-asasac-an2"
    key    = "asasac/platform.tfstate"
    region = "ap-northeast-2"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_default_tags" "current" {}

data "aws_kms_key" "rds" {
  key_id = "alias/aws/rds"
}