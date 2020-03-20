resource "aws_launch_configuration" "ec2_launch_configuration" {
  image_id                    = "ami-03ba3948f6c37a4b0"
  instance_type               = "t2.micro"
  key_name                    = "nginx"
  security_groups             = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = "true"
  name                        = "ec2-autoscaling-configuration"
}

resource "aws_autoscaling_group" "ec2_autoscaling_group" {
  name                      = "ec2-instance-autoscaling"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = [aws_subnet.main_public_1.id, aws_subnet.main_public_2.id]
  launch_configuration      = aws_launch_configuration.ec2_launch_configuration.name
  force_delete              = "true"
  tag {
    key                 = "Name"
    value               = "ec2_instance"
    propagate_at_launch = true
  }
}

# Creating Autoscaling Policy
resource "aws_autoscaling_policy" "ec2_autoscaling_group_policy_scaleup" {
  name                   = "ec2_autoscaling_group_policy_scaleup"
  autoscaling_group_name = aws_autoscaling_group.ec2_autoscaling_group.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
  scaling_adjustment     = "1"

}

resource "aws_autoscaling_policy" "ec2_autoscaling_group_policy_scaledown" {
  name                   = "ec2_autoscaling_group_policy_scaledown"
  autoscaling_group_name = aws_autoscaling_group.ec2_autoscaling_group.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
  scaling_adjustment     = "-1"
}

resource "aws_cloudwatch_metric_alarm" "ec2_cloudwatch_alam_scaleup" {
  alarm_name          = "ec2_cloudwatch_alam_scaleup"
  alarm_description   = " Alarm to scale up the EC2 instance"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.ec2_autoscaling_group.name
  }

  actions_enabled = "true"
  alarm_actions   = [aws_autoscaling_policy.ec2_autoscaling_group_policy_scaleup.arn]
}

resource "aws_cloudwatch_metric_alarm" "ec2_cloudwatch_alam_scaledown" {
  alarm_name          = "ec2_cloudwatch_alam_scaledown"
  alarm_description   = "Alarm to scale down the EC2 instance"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.ec2_autoscaling_group.name
  }

  actions_enabled = "true"
  alarm_actions   = [aws_autoscaling_policy.ec2_autoscaling_group_policy_scaledown.arn]
}



