variable "AWS_ACCESS_KEY" {
      default = "var.AWS_ACCESS_KEY"
}

variable "AWS_SECRET_KEY" {
      default = "var.AWS_ACCESS_KEY"
}

variable "AMIS" {
  type = map
  default = {
        us-west-1 = "ami-03ba3948f6c37a4b0"
        us-west-2 = "ami-0d1cd67c26f5fca19"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
   default = "./ssh/nginx"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "./ssh/nginx.pub"
}

variable "INSTANCE_USERNAME" {
      default = "ubuntu"
}

variable "AWS_REGION" {
      default = "var.AWS_REGION"
}







