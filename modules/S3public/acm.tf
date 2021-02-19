resource "aws_acm_certificate" "cert" {
  domain_name       = "*.averism.com"
  validation_method = "DNS"

  tags = {
    Name = "wildcard"
  }

  lifecycle {
    create_before_destroy = true
  }
}