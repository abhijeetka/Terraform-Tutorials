provider "aws" {
  region = var.region
}

terraform {
  cloud {
    organization = "abhijeetka"

    workspaces {
      name = "terraform-cli"
    }
  }
}