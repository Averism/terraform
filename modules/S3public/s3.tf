locals {
    bucketname = "${var.alias==null?var.subdomain:var.alias}.${var.domain}"
    origin_id = "S3-${local.bucketname}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucketname
  acl    = "public-read"
    website {
        index_document = "index.html"
        error_document = "error.html"
    }
  
    cors_rule {
      allowed_headers = []
      allowed_methods = [
          "GET",
        ] 
      allowed_origins = [
          "*",
        ]
      expose_headers  = []
      max_age_seconds = 0
    }
}
