resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_vpc_public" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "main_vpc_public"
  }
}

resource "aws_internet_gateway" "main_vpc_ig" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_vpc_ig"
  }
}

resource "aws_route_table" "internet_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    gateway_id = aws_internet_gateway.main_vpc_ig.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "route_table_associate_main_vpc_public" {
  subnet_id      = aws_subnet.main_vpc_public.id
  route_table_id = aws_route_table.internet_route_table.id
}
