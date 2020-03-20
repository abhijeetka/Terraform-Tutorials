

resource "aws_iam_role_policy" "ecs-ec2-role-policy"{
      name = "ecs-ec2-role-policy"
      role = aws_iam_role.ecs-ec2-role.id
      policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource":  "*" 
      }
    ]
  }
  EOF
}


resource "aws_iam_role" "ecs-ec2-role" {
	  name               = "ecs-ec2-role"
	  assume_role_policy = <<EOF
	{
	  "Version": "2012-10-17",
	  "Statement": [
	    {
	      "Action": "sts:AssumeRole",
	      "Principal": {
	        "Service": "ec2.amazonaws.com"
	      },
	      "Effect": "Allow",
	      "Sid": ""
	    }
	  ]
	}
	EOF
	
}


resource "aws_iam_instance_profile" "ecs-ec2-role" {
name = "ecs-ec2-role"
role = aws_iam_role.ecs-ec2-role.name
}


resource "aws_iam_role" "ecs-consul-server-role" {
	  name = "ecs-consul-server-role"
	  assume_role_policy = <<EOF
	{
	  "Version": "2012-10-17",
	  "Statement": [
	    {
	      "Action": "sts:AssumeRole",
	      "Principal": {
	        "Service": "ec2.amazonaws.com"
	      },
	      "Effect": "Allow",
	      "Sid": ""
	    }
	  ]
	}
	EOF
	
	}