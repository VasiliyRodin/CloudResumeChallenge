resource "aws_s3_bucket" "myBucket" {
  bucket = "vr-bucket-static-site"
  tags = {
    Name        = "My bucket"
  }
}
//This makes sure you own all the files in the bucket, no matter who puts them in.
resource "aws_s3_bucket_ownership_controls" "myBucket" {
    bucket = aws_s3_bucket.myBucket.id
    rule {
      object_ownership = "BucketOwnerEnforced"
    }
}
//This flips the safety switches so people on the internet can/can't look inside (read files) if you say so.
resource "aws_s3_bucket_public_access_block" "myBucket" {
  bucket                  = aws_s3_bucket.myBucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

//Tells the bucket its a web host pointing to the index and 404 of the site
/* resource "aws_s3_bucket_website_configuration" "myBucket" {
  bucket = aws_s3_bucket.myBucket.id
  index_document { suffix = "index.html" }
  error_document { key    = "404.html" }
} */

# this writes a permission slip that says, "Anyone can look at the files in this s3, but they can’t take or change them
/* data "aws_iam_policy_document" "public_read_my_bucket" {
  statement {
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    principals { 
        type = "AWS"
        identifiers = ["*"] 
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.myBucket.arn}/*"]
  }
}
 *///attaches the permission slip to the bucket
/* resource "aws_s3_bucket_policy" "myBucket" {
    bucket = aws_s3_bucket.myBucket.id
    policy = data.aws_iam_policy_document.public_read_my_bucket.json
    depends_on = [aws_s3_bucket_public_access_block.myBucket]
}//We are removing this so that only cloudfront will be able to access.
 */
//readonly variables called local
/* locals {
  files=[   
    {key="index.html", path = "../resume/index.html", type="text/html"},
    {key ="index.css", path = "../resume/index.html", type="text/css"}
    ]
} */
//upload the files to the s3 bucket
/* resource "aws_s3_object" "myBucket" {
    for_each = {for file in local.files: file.key => file}
    bucket = aws_s3_bucket.myBucket.id
    key = each.value.key // Whats its going to be called in the s3 bucket
    source = each.value.path
    content_type = each.value.type
    etag = filemd5(each.value.path)
} */