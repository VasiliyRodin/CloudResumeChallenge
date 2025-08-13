resource "aws_s3_bucket" "myTfBucket" {
  bucket = "vr-bucket-static-site"

  tags = {
    Name        = "My bucket"
  }
}