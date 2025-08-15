resource "aws_route53_zone" "vr-site-r53" {
    name = "vasiliyrodin.com"
}

output "dnsOutput" {
    value = aws_route53_zone.vr-site-r53.name_servers
}