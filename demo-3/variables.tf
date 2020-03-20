

variable "AWS_ACCESS_KEY" {
      default = "var.AWS_ACCESS_KEY"
}

variable "AWS_SECRET_KEY" {
      default = "var.AWS_SECRET_KEY"
}

variable "AWS_REGION" {
      default = "var.AWS_REGION"
}

variable "AMIS" {
      type = map
      default = {
            us-west-1 = "ami-03ba3948f6c37a4b0"
            us-west-2 = "ami-0d1cd67c26f5fca19"
      }
}
variable "INSTANCE_TYPE" {
      default = "t2.micro"
}

