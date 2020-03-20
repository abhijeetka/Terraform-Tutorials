resource "aws_instance" "r53_instance" {
  ami           = "ami-03ba3948f6c37a4b0"
  instance_type = "t2.micro"
}

resource "aws_eip" "eip_r53_instance" {
  instance = aws_instance.r53_instance.id
  vpc      = "true"
}

resource "aws_route53_zone" "r53_zone" {
  name = "abhijeet.ka"
}

resource "aws_route53_record" "r53_record" {
  zone_id = aws_route53_zone.r53_zone.id
  type    = "A"
  name    = "www.abhijeet.ka"
  ttl     = "300"
  records = [aws_eip.eip_r53_instance.public_ip]
}

output "eip" {
  value = aws_eip.eip_r53_instance
}

output "route53" {
  value = aws_route53_zone.r53_zone
}

output "record53" {
  value = aws_route53_record.r53_record
}



