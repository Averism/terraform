module acm {
    source = "../acm/us-east-1"
    domain = var.domain
    subdomain = var.subdomain
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_domain_name
    origin_id   = local.origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${var.subdomain}.${var.domain}"]

  custom_error_response {
    error_code = 404
    response_code = 404
    response_page_path = var.custom404
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 1
  }
  
  viewer_certificate {
    acm_certificate_arn            = module.acm.arn
    cloudfront_default_certificate = false 
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "sni-only"
  }
}

data "aws_route53_zone" "zone" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_record" "cloudfront_cname" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.subdomain}.${var.domain}"
  type    = "CNAME"
  ttl     = "1800"
  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
}