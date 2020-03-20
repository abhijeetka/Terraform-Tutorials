resource "aws_iam_role" "s3_mybucket_role" {
  name               = "s3-mybucket-role"
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
  tags = {
    Name = "aws-iam-role-s3-mybucket"
  }

}

resource "aws_iam_instance_profile" "s3_mybucket_role_instance_profile" {
  name  = "aws_s3_mybucket_role_instance_profile"
  role = aws_iam_role.s3_mybucket_role.name
}


resource "aws_iam_role_policy" "my_s3_bucket_role_policy" {
  name   = "my-s3-role-policy"
  role   = aws_iam_role.s3_mybucket_role.id
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
