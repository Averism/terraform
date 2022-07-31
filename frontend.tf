module frontend_cd {
    source = "./frontend/cd"
    s3_bucket_location = "static.averism.com"
}

data "aws_iam_policy_document" "allow_access_from_codebuild" {
  statement {
    principals {
        type = "arn"
        identifiers = module.frontend_cd.outputs.role_arn
    }

    actions = [
      "s3:*"
    ]

    resources = [
      module.static.outputs.bucketarn,
      "${module.static.outputs.bucketarn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = module.static.outputs.bucketname
  policy = data.aws_iam_policy_document.allow_access_from_codebuild.json
}
