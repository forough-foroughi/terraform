variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_bucket_tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
}

 
variable "s3_object_key" {
    description = "Key (path) for the object in the S3 bucket"
    type = string

}

variable  "s3_object_source" {
    description = "Path to the local file to upload to s3"
    type = string
}