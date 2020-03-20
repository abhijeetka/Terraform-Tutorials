resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-main"
  }
}

#creating two subnets
resource "aws_subnet" "main_public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-west-1a"
  tags = {
    Name = "vpc-main-public-1"
  }
}

resource "aws_subnet" "main_public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-west-1c"
  tags = {
    Name = "vpc-main-public-2"
  }
}

resource "aws_internet_gateway" "ig_main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ig-main"
  }
}

resource "aws_route_table" "ig_route_main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_main.id
  }
}

resource "aws_route_table_association" "ig_route_table_associate_1" {
  subnet_id      = aws_subnet.main_public_1.id
  route_table_id = aws_route_table.ig_route_main.id
}

resource "aws_route_table_association" "ig_route_table_associate_2" {
  subnet_id      = aws_subnet.main_public_2.id
  route_table_id = aws_route_table.ig_route_main.id
}

