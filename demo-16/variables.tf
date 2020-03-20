variable "AWSREGION" {
  default = "us-west-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "availability_zones" {
  default = [
    "us-west-1a",
    "us-west-1c"
  ]
}
