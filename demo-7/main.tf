
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "main-public"
  }
}

resource "aws_subnet" "main_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "main-private"
  }
}

resource "aws_internet_gateway" "ig_us_west_1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Main-IG"
  }
}

resource "aws_route_table" "route_table" {
      vpc_id = aws_vpc.main.id
      route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.ig_us_west_1.id
      }
  
}

resource "aws_route_table_association" "main_public_route" {
      subnet_id = aws_subnet.main_private.id
      route_table_id = aws_route_table.route_table.id

}

output "vpc" {
  value = aws_vpc.main
}
output "internet_gateway" {
  value = aws_internet_gateway.ig_us_west_1
}






