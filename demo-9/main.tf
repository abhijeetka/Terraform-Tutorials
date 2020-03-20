# This will create a vpc named main

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

# Creating two subnets
resource "aws_subnet" "main_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "main-vpc-public"
  }
}

resource "aws_subnet" "main_private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "main-vpc-private"
  }
}

# Creating AWS IG 
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

# associating Route table with vpc subnet
resource "aws_route_table_association" "ig_main_public_link" {
  subnet_id      = aws_subnet.main_public.id
  route_table_id = aws_route_table.ig_public_route.id
}

# Create AWS security group for ssh
resource "aws_security_group" "allow_ssh" {
  name   = "allow-ssh"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EBS Volume
resource "aws_ebs_volume" "ebs_vol_test" {
  availability_zone = "us-west-1c"
  size              = 10
  type              = "gp2"
  tags = {
    Name = "ebs-test-vol"
  }
}

resource "aws_volume_attachment" "ebs_vol_test_attach" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs_vol_test.id
  instance_id = aws_instance.vpc_test.id
}

resource "aws_instance" "vpc_test" {
  ami                    = "ami-03ba3948f6c37a4b0"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main_public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = "nginx"
}





