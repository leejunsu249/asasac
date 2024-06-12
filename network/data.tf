data "aws_availability_zones" "available" {
  all_availability_zones = true

  filter {
    name   = "zone-name"
    values = ["ap-northeast-2a", "ap-northeast-2b"]
  }
}

data "aws_iam_policy_document" "generic_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:SourceVpc"

      values = [module.asasac_vpc.vpc_id]
    }
  }
}
