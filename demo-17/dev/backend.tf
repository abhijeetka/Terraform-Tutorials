terraform {
  backend "s3" {
    bucket         = "837449071151-other-account"
    key            = "terraform-iac/terraform.tfstate"
    region         = "us-east-1"
    role_arn	   = "arn:aws:iam::837449071151:role/terraform-iac"
    dynamodb_table = "837449071151-other-account-dynamodb"
  }
}

