variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}
variable "s3_static_bucket_name" {
  description = "Name of the S3 static website bucket"
  type        = string
} 

variable "s3_force_destroy" {
  description = "Force Destroy"
  type = bool
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

variable "s3_index_file" {
  type        = string
  description = "Path to website index file"
}

variable "s3_error_file" {
  type        = string
  description = "Path to website error file"
}