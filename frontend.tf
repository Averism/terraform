module frontend_cd {
    source = "./frontend/cd"
    s3_bucket_location = "static.averism.com"
}

data "aws_iam_policy_document" "allow_access_from_codebuild" {
  statement {
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
  count = var.policy == null ? 0 : 1
  bucket = module.static.outputs.bucketname
  policy = data.aws_iam_policy_document.allow_access_from_codebuild.json
}
