data "aws_iam_policy_document" "bucket_read_only" {
  statement {
    effect    = "Allow"
    actions   = [
        "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.s3-bucket.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}