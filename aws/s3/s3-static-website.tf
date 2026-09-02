module "s3_static_website" {
  source = "./modules/s3-static-website"
  bucket_name   = var.s3_static_bucket_name
  tags          = var.s3_bucket_tags

  index_file = var.s3_index_file
  error_file = var.s3_error_file
}
