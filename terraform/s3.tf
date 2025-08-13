resource "aws_s3_bucket" "myTfBucket" {
  bucket = "vr-bucket-static-site"

  tags = {
    Name        = "My bucket"
  }
}
//This makes sure you own all the files in the bucket, no matter who puts them in.
resource "aws_s3_bucket_ownership_controls" "myTfBucket" {
    bucket = aws_s3_bucket.myTfBucket.id
    rule {
      object_ownership = "BucketOwnerEnforced"
    }
}
//This flips the safety switches so people on the internet can look inside (read files) if you say so.
resource "aws_s3_bucket_public_access_block" "myTfBucket" {
  bucket                  = aws_s3_bucket.myTfBucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

//Tells the bucket its a web host pointing to the index and 404 of the site
resource "aws_s3_bucket_website_configuration" "myTfBucket" {
  bucket = aws_s3_bucket.myTfBucket.id
  index_document { suffix = "index.html" }
  error_document { key    = "404.html" }
}

# this writes a permission slip that says, "Anyone can look at the files in this s3, but they can’t take or change them
data "aws_iam_policy_document" "public_read_my_bucket" {
  statement {
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    principals { 
        type = "AWS"
        identifiers = ["*"] 
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.myTfBucket.arn}/*"]
  }
}
//attaches the permission slip to the bucket
resource "aws_s3_bucket_policy" "myTfBucket" {
    bucket = aws_s3_bucket.myTfBucket.id
    policy = data.aws_iam_policy_document.public_read_my_bucket.json
    depends_on = [aws_s3_bucket_public_access_block.myTfBucket]
}

//readonly variables called local
locals {
  files=[   
    {key="index.html", path = "../resume/index.html", type="text/html"},
    {key ="index.css", path = "../resume/index.html", type="text/css"}
    ]
}
//upload the files to the s3 bucket
resource "aws_s3_object" "myTfBucket" {
    for_each = {for file in local.files: file.key => file}
    bucket = aws_s3_bucket.myTfBucket.id
    key = each.value.key // Whats its going to be called in the s3 bucket
    source = each.value.path
    content_type = each.value.type
    etag = filemd5(each.value.path)
}