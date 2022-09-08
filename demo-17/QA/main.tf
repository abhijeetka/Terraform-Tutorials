
# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.vpc_name}-${var.environment}"
  }

}

locals {
  name = "${var.service_name}-${var.environment}"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.subnet_range_public-1
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.subnet_name}-${var.environment}"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.subnet_range_public-2
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.subnet_name}-${var.environment}"
  }
}

# Create a subnet to launch our instances into
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.subnet_range_private
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.subnet_name}-${var.environment}"
  }
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "${var.elb_sg_name}-${var.environment}"
  description = "Used in the terraform ${var.environment}"
  vpc_id      = aws_vpc.default.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "${var.sg_name}-${var.environment}"
  description = "Used in the terraform ${var.environment}"
  vpc_id      = aws_vpc.default.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}-${var.environment}"
  public_key = file(var.public_key_path)
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = "${local.name}-lb"

  load_balancer_type = "application"

  vpc_id          = aws_vpc.default.id
  subnets         = [aws_subnet.public1.id,aws_subnet.public2.id]
  security_groups = [aws_security_group.default.id]


  target_groups = [
    {
      name             = "tg-${local.name}"
      backend_protocol = "HTTP"
      backend_port     = 80
      health_check = {
        path = "/"
        port = 80
        healthy_threshold = 5
        unhealthy_threshold = 2
        timeout = 5
        interval = 15
        matcher = "200-302"  # has to be HTTP 200 or fails
      }
    }

  ]


  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]


  tags = {
    Environment = var.environment
  }
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.9.0"
  name = local.name

  # Launch configuration
  key_name = aws_key_pair.auth.key_name
  lc_name = "${local.name}-lc"
  associate_public_ip_address  = true
  image_id        = var.aws_amis
  instance_type   = var.instance_type
  security_groups = [aws_security_group.default.id]

  root_block_device = [
    {
      volume_size = "70"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "${local.name}-asg"
  vpc_zone_identifier       = [aws_subnet.private.id]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "lazsa"
      propagate_at_launch = true
    },
  ]
  target_group_arns    = module.alb.target_group_arns
  iam_instance_profile = "ec2-ssm-role"
  user_data = templatefile("${path.module}/init.tftpl",{})
}
