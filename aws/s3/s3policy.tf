resource "aws_s3_bucket_policy" "bucket_read_only" {
  bucket = aws_s3_bucket.s3-bucket.id

  policy = data.aws_iam_policy_document.bucket_read_only.json
}