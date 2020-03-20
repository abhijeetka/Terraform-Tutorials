terraform{
      backend "s3" {
            bucket = "terraform-backend-13022020"
            region = "us-west-1"
            key = "demo-4/terraform.tfstate"
      }
}