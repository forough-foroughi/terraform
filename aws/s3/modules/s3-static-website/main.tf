resource "aws_s3_bucket" "my-website" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_ownership_controls" "my-website" {
  bucket = aws_s3_bucket.my-website.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "my-website" {
  bucket                  = aws_s3_bucket.my-website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "my-website" {
  bucket = aws_s3_bucket.my-website.id
  index_document {
    suffix = var.index_document
  }
  error_document {
    key = var.error_document
  }
}

data "aws_iam_policy_document" "public_read" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.my-website.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "my-website" {
  bucket     = aws_s3_bucket.my-website.id
  policy     = data.aws_iam_policy_document.public_read.json
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my-website.id
  key          = var.index_document
  source       = var.index_file
  content_type = "text/html"
  etag         = filemd5(var.index_file)
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my-website.id
  key          = var.error_document
  source       = var.error_file
  content_type = "text/html"
  etag         = filemd5(var.error_file)
}