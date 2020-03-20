resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "my-s3-bucket-123"
  acl  = "private"
  tags = {
    Name = "my-s3-bucket"
  }
}
