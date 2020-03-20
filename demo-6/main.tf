module "aws_ec2_inst" {
  source        = "./modules/aws-ec2"
  ami           = "ami-03ba3948f6c37a4b0"
  instance_type = "t2.micro"

}
