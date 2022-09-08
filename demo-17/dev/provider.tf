
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
    #
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

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_id
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        "${var.cluster_name}-${var.environment}"
      ]
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_id
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      "${var.cluster_name}-${var.environment}"
    ]
  }
}