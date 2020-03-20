

resource "aws_instance" "sample-backend" {
  instance_type = var.INSTANCE_TYPE
  ami = lookup(var.AMIS,var.AWS_REGION)
}
