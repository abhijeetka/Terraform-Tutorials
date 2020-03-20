
resource "aws_ecr_repository" "ecr_demo" {
  name                 = "ecr_demo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

}


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_test"
}

resource "aws_launch_configuration" "ecs-example-launchconfig" {
  name_prefix          = "ecs-launchconfig"
  image_id             = "ami-03ba3948f6c37a4b0"
  instance_type        = var.instance_type
  key_name             = "nginx"
  iam_instance_profile = aws_iam_instance_profile.ecs-ec2-role.id
  security_groups      = [aws_security_group.ecs-securitygroup.id]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=example-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs-example-autoscaling" {
  name                 = "ecs-example-autoscaling"
  vpc_zone_identifier  = [aws_subnet.main_vpc_public.id]
  launch_configuration = aws_launch_configuration.ecs-example-launchconfig.name
  min_size             = 1
  max_size             = 1
  tag {
    key                 = "Name"
    value               = "ecs-ec2-container"
    propagate_at_launch = true
  }
}

output "ecr_demo_url" {
  value = aws_ecr_repository.ecr_demo.repository_url
}
