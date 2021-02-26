variable "domain" {
    type = string
}

variable "subdomain" {
    type = string
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.subdomain}.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name = var.subdomain
  }

  lifecycle {
    create_before_destroy = true
  }
}

output arn {
    value = aws_acm_certificate.cert.arn
}