
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
  cloud {
        organization = "abhijeetka"
        workspaces {
          name = "tf-demo-dev"
        }
  }


}


provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn    = var.assume_role_name
    external_id = "my_external_id"
  }
}

