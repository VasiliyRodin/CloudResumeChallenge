resource "aws_acm_certificate" "myCert" {
    domain_name = "vasiliyrodin.com"
    validation_method = "DNS"
    lifecycle {
      create_before_destroy = true
    }
}



