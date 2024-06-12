
terraform {
  backend "s3" {
      bucket         = "p-terraform-asasac-an2"
      key            = "asasac/db.tfstate"
      region         = "ap-northeast-2"
      encrypt        = true
      dynamodb_table = "p-dynamo-an2-asasac-terraform-lock"
  }
}