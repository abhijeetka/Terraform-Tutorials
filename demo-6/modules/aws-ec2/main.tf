resource "aws_instance" "aws_ec2" {
  instance_type = var.instance_type
  ami           = var.ami
}
