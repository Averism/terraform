variable "domain" {
    type = string
}

resource "aws_route53_zone" "hostedzone" {
    name       = var.domain
    comment    = "HostedZone created by Route53 Registrar"
}

output "id" {
    value = aws_route53_zone.hostedzone.id
}
