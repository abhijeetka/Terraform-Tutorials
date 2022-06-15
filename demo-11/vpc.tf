resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main_private" {
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = "false"
  tags = {
    Name = "main-private-subnet"
  }
}

resource "aws_subnet" "main_private2" {
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = "false"
  tags = {
    Name = "main-private2-subnet"
  }
}

resource "aws_subnet" "main_public" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = "true"
  tags = {
    Name = "main-privage-subnet"
  }
}




