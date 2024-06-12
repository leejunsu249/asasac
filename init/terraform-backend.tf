resource "aws_s3_bucket" "s3-tf-state" {

    bucket = "p-terraform-asasac-an2"

    tags = {
        "Name" = "p-terraform-asasac-an2",
    }
}

resource "aws_dynamodb_table" "ddb-tf-lock" {
    
    depends_on   = [aws_s3_bucket.s3-tf-state]
    name         = "p-dynamo-an2-asasac-terraform-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    tags = {
        "Name" = "p-dynamo-an2-asasac-terraform-lock",       
  }
  
}

terraform {
  backend "s3" {
      bucket         = "p-terraform-asasac-an2"
      key            = "init/backend.tfstate"
      region         = "ap-northeast-2"
      encrypt        = true
      dynamodb_table = "p-dynamo-an2-asasac-terraform-lock"
  }
}