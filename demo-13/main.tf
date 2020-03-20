resource "aws_instance" "nginx" {
  ami                    = "ami-03ba3948f6c37a4b0"
  instance_type          = "t2.micro"
  key_name               = "nginx"
  subnet_id              = aws_subnet.main_public.id
  vpc_security_group_ids = [aws_security_group.nginx_instance.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_mybucket_role_instance_profile.name
}

resource "aws_security_group" "nginx_instance" {
  vpc_id = aws_vpc.main.id
  name   = "nginx-instance-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "ig_main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ig-main"
  }
}

# Creating Route Table
resource "aws_route_table" "ig_public_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_main.id
  }
}

resource "aws_route_table_association" "ig_main_public_link" {
  subnet_id      = aws_subnet.main_public.id
  route_table_id = aws_route_table.ig_public_route.id
}


