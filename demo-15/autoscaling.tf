#resource "aws_launch_configuration" "ec2_launch_configuration" {
#  image_id                    = "ami-052efd3df9dad4825"
#  instance_type               = "t2.micro"
#  key_name                    = "nginx"
#  security_groups             = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id ]
#  associate_public_ip_address = "true"
#  name                        = "ec2-autoscaling-configuration"
#  user_data                   = "#!/bin/bash\napt-get update\napt-get -y install nginx\nMYIP=`ifconfig | grep 'inet' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'this is: '$MYIP > /var/www/html/index.html"
#  lifecycle {
#    create_before_destroy = true
#  }
#}
#
#resource "aws_autoscaling_group" "ec2_autoscaling_group" {
#  name                      = "ec2-instance-autoscaling"
#  max_size                  = 3
#  min_size                  = 2
#  health_check_grace_period = 300
#  health_check_type         = "ELB"
#  load_balancers            = [aws_elb.my_elb.name]
#  vpc_zone_identifier       = [aws_subnet.main_public_1.id, aws_subnet.main_public_2.id]
#  launch_configuration      = aws_launch_configuration.ec2_launch_configuration.name
#  force_delete              = "true"
#  tag {
#    key                 = "Name"
#    value               = "ec2_instance"
#    propagate_at_launch = true
#  }
#}
#
## Creating Autoscaling Policy
#resource "aws_autoscaling_policy" "ec2_autoscaling_group_policy_scaleup" {
#  name                   = "ec2_autoscaling_group_policy_scaleup"
#  autoscaling_group_name = aws_autoscaling_group.ec2_autoscaling_group.name
#  adjustment_type        = "ChangeInCapacity"
#  policy_type            = "SimpleScaling"
#  cooldown               = 300
#  scaling_adjustment     = "1"
#
#}
#
#resource "aws_autoscaling_policy" "ec2_autoscaling_group_policy_scaledown" {
#  name                   = "ec2_autoscaling_group_policy_scaledown"
#  autoscaling_group_name = aws_autoscaling_group.ec2_autoscaling_group.name
#  adjustment_type        = "ChangeInCapacity"
#  policy_type            = "SimpleScaling"
#  cooldown               = 300
#  scaling_adjustment     = "-1"
#}
#
#resource "aws_cloudwatch_metric_alarm" "ec2_cloudwatch_alam_scaleup" {
#  alarm_name          = "ec2_cloudwatch_alam_scaleup"
#  alarm_description   = " Alarm to scale up the EC2 instance"
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/EC2"
#  period              = "120"
#  statistic           = "Average"
#  threshold           = "5"
#
#  dimensions = {
#    "AutoScalingGroupName" = aws_autoscaling_group.ec2_autoscaling_group.name
#  }
#
#  actions_enabled = "true"
#  alarm_actions   = [aws_autoscaling_policy.ec2_autoscaling_group_policy_scaleup.arn]
#}
#
#resource "aws_cloudwatch_metric_alarm" "ec2_cloudwatch_alam_scaledown" {
#  alarm_name          = "ec2_cloudwatch_alam_scaledown"
#  alarm_description   = "Alarm to scale down the EC2 instance"
#  comparison_operator = "LessThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/EC2"
#  period              = "120"
#  statistic           = "Average"
#  threshold           = "5"
#
#  dimensions = {
#    "AutoScalingGroupName" = aws_autoscaling_group.ec2_autoscaling_group.name
#  }
#
#  actions_enabled = "true"
#  alarm_actions   = [aws_autoscaling_policy.ec2_autoscaling_group_policy_scaledown.arn]
#}
#
#
#
