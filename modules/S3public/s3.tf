variable "bucketname" {
    type = string
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucketname
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