resource "aws_ses_domain_identity" "email_domain" {
  domain = var.domain
}

resource "aws_route53_record" "verification_record" {
  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "1800"
  records = [aws_ses_domain_identity.email_domain.verification_token]
}

resource "aws_route53_record" "mx_record" {
    zone_id = var.zone_id
    name    = var.domain
    type    = "MX"
    records = ["10 inbound-smtp.${var.emailregion}.amazonaws.com"]
    ttl     = "300"
}

resource "aws_ses_domain_dkim" "email_dkim" {
  domain = var.domain
}

resource "aws_route53_record" "email_dkim_verification" {
  count   = 3
  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.email_dkim.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "1800"
  records = ["${element(aws_ses_domain_dkim.email_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}