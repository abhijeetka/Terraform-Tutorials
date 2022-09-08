variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/terraform.pub
DESCRIPTION
  default = "id_rsa.pub"
  sensitive = "true"
}

variable "private_key_path" {
  description = <<DESCRIPTION
Path to the SSH private key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/terraform
DESCRIPTION
  default = "id_rsa"
  sensitive = "true"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "terraform-iac"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_amis" {
  description = "AWS AMI to launch servers"
  default = "ami-08d4ac5b634553e16"
}

variable "instance_name" {
  description = "instance_name"
  default = "terraform-iac-default-instance-name"
}
variable "elb_name" {
  description = "elb_name"
  default = "tf-iac-elb"
}
variable "sg_name" {
  description = "sg_name"
  default = "terraform-iac-default-sg-name"
}
variable "elb_sg_name" {
  description = "elb_sg_name"
  default = "terraform-iac-default-elb-sg-name"
}
variable "subnet_name" {
  description = "subnet_name"
  default = "terraform-iac-default-subnet-name"
}
variable "vpc_name" {
  description = "vpc_name"
  default = "terraform-iac-default-vpc-name"
}
variable "vpc_cidr" {
  description = "vpc_cidr"
  default = "10.0.0.0/16"
}


variable "subnet_range_public-1" {
  description = "vpc_cidr"
  default = "10.0.1.0/24"
}

variable "subnet_range_public-2" {
  description = "vpc_cidr"
  default = "10.0.2.0/24"
}

variable "subnet_range_private" {
  description = "vpc_cidr"
  default = "10.0.3.0/24"
}

variable "assume_role_name" {
  default = "arn:aws:iam::628740878687:role/tf-assume-role"
}

variable "environment" {
  default = "dev"
}

variable "service_name" {
  default = "tf-demo"
}

variable "instance_type" {
  default = "t2.small"
}