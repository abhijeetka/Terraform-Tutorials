

resource "aws_instance" "nginx" {
  instance_type = var.INSTANCE_TYPE
  ami = lookup(var.AMIS,var.AWS_REGION)
}

output "nginx_public_ip" {
  value = aws_instance.nginx.public_ip
}

output "nginx_public_dns" {
      value = aws_instance.nginx.public_dns
}
