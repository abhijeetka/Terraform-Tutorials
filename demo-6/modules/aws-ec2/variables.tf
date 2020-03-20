variable "ami" {
  description = "ID of the AMI to be used"
  type        = string
}

variable "instance_type" {
  description = "Defines the Instance type"
  type        = string
  default     = "t2.micro"
}

