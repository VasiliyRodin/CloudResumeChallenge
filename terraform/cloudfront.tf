resource "aws_cloudfront_origin_access_control" "my-site-cf-oac" {
    name                                = "my-site-cf-oac"
    origin_access_control_origin_type   = "s3"
    signing_behavior                    = "always"
    signing_protocol                    = "sigv4"
}
resource "aws_cloudfront_distribution" "my-site-cf" {
    aliases = [ "vasiliyrodin.com" ]
    enabled             = true
    default_root_object = "index.html"
    # --- Define the origin (where CloudFront fetches content) ---
    origin {
        domain_name                     = aws_s3_bucket.myBucket.bucket_regional_domain_name
        origin_id                       = "s3-origin"
        origin_access_control_id        = aws_cloudfront_origin_access_control.my-site-cf-oac.id
    }
    # --- How CloudFront serves requests by default ---
    default_cache_behavior {
        target_origin_id = "s3-origin"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods = ["GET","HEAD"]
        cached_methods = ["GET","HEAD"]
        cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" //It’s the official managed policy for static sites
    }
    price_class = "PriceClass_100"
    # --- The cert that we use default for now
    viewer_certificate {
        //cloudfront_default_certificate = true
        acm_certificate_arn      = aws_acm_certificate.myCert.arn
        ssl_support_method       = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
    }
    # --- No geo restrictions ---
    restrictions {
        geo_restriction {
          restriction_type = "none"
        }
    } 
}

data "aws_caller_identity" "current" {}
//assigns the s3 bucket with the permission for cloudfront to access it and get objects.
resource "aws_s3_bucket_policy" "my-site-s3-policy" {
  bucket = aws_s3_bucket.myBucket.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.myBucket.arn}/*"  # instead of data.aws_s3_bucket.site.arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.my-site-cf.id}"
          }
        }
      }
    ]
  })
}


