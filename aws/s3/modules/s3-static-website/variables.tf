variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "index_document" {
  description = "Website index document key"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Website error document key"
  type        = string
  default     = "error.html"
}


variable "force_destroy" {
  description = "Delete objects when destroying the bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the bucket"
  type        = map(string)
  default     = {}
}

variable "index_file" {
  description = "Local path to the website index file"
  type        = string
}

variable "error_file" {
  description = "Local path to the website error file"
  type        = string
}