output "bucket_name" {
  value = aws_s3_bucket.my-website.id
}

output "bucket_arn" {
  value = aws_s3_bucket.my-website.arn
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.my-website.website_endpoint
}

output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.my-website.website_endpoint}"
}