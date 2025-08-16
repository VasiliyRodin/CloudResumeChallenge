resource "aws_acm_certificate" "myCert" {
    domain_name = "vasiliyrodin.com"
    validation_method = "DNS"
    lifecycle {
      create_before_destroy = true
    }
}
/* data "aws_rout53_zone" "rout53_zone" {
    name = "vasiliyrodin.com"
    private_zone = false
} */
resource "aws_route53_record" "myCertR54Record" {
  for_each = {
    for dvo in aws_acm_certificate.myCert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.vr-site-r53.zone_id
}

resource "aws_acm_certificate_validation" "myCertValidation" {
    certificate_arn = aws_acm_certificate.myCert.arn
    validation_record_fqdns = [for record in aws_route53_record.myCertR54Record:record.fqdn]
}



