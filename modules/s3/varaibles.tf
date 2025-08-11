variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to the S3 bucket."
}

variable "bucket_policy" {
  type        = string
  description = "The JSON-encoded bucket policy"
  default     = ""
}