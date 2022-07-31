variable s3_bucket_location {
    type = "string"
}

resource "aws_s3_bucket" "averism_codebuild_cache" {
  bucket = "averism-codebuil-cache"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role" "averism_codebuild_role" {
  name = "averism_codebuild_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "averism_codebuild_policy" {
  role = aws_iam_role.averism_codebuild_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*",
        "*/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "averism_codebuild_frontend" {
  name          = "averism_frontend"
  description   = "cd for averism frontend"
  build_timeout = "30"
  service_role  = aws_iam_role.averism_codebuild_role.arn

  artifacts {
    type = "S3"
    location = var.s3_bucket_location
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.averism_codebuild_cache.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }

    environment_variable {
      name  = "SOME_KEY2"
      value = "SOME_VALUE2"
      type  = "PARAMETER_STORE"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/Averism/averism-front-end"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  tags = {
    ManagedBy = "Terraform"
    Service = "Frontend"
  }
}

output "role_arn" {
  value = aws_iam_role.averism_codebuild_role.arn
}
