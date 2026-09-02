resource "aws_s3_bucket" "s3-bucket" {
    bucket = var.s3_bucket_name
    tags = var.s3_bucket_tags
    force_destroy = var.s3_force_destroy

}

resource "aws_s3_object" "upload-object"{
    bucket = aws_s3_bucket.s3-bucket.id
    key = var.s3_object_key
    source = var.s3_object_source

}