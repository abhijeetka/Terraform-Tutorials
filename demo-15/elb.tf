resource "aws_elb" "my_elb" {
  name            = "my-elb-cli"
  subnets         = [aws_subnet.main_public_1.id, aws_subnet.main_public_2.id]
  security_groups = [aws_security_group.allow_http.id]
  #instances       = [ aws_autoscaling_group.ec2_autoscaling_group.id ]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = "80"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 300
  tags = {
    Name = "my-elb"
  }
}
