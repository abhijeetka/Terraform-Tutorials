#resource "aws_instance" "example" {
# ami                    = "ami-03ba3948f6c37a4b0"
#  instance_type          = "t2.micro"
#  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
#  subnet_id              = aws_subnet.main_public.id
#  key_name               = "nginx"
#}

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

