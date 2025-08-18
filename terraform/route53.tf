resource "aws_route53_zone" "vr-site-r53" {
    name = "vasiliyrodin.com"
}

output "dnsOutput" {
    value = aws_route53_zone.vr-site-r53.name_servers
}

resource "aws_route53_record" "cf_r53_record" {
    zone_id = aws_route53_zone.vr-site-r53.zone_id
    name    = "vasiliyrodin.com"
    type    = "A"
    alias {
        name    = aws_cloudfront_distribution.my-site-cf.domain_name
        zone_id = aws_cloudfront_distribution.my-site-cf.hosted_zone_id
        evaluate_target_health = false
    }
}