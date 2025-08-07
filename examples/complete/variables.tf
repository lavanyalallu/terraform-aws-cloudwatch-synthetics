variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name for resources"
  type        = string
  default     = "canary"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "test"
}

variable "label_order" {
  description = "Order for labels"
  type        = list(string)
  default     = ["name", "environment"]
}

variable "schedule_expression" {
  description = "Canary schedule"
  type        = string
  default     = "rate(5 minutes)"
}

variable "s3_artifact_bucket" {
  description = "Name of the S3 bucket for canary artifacts"
  type        = string
 default     = "lavaching908"
}

variable "alarm_email" {
  description = "Email for alarm notifications"
  type        = string
  default     = ""
}

variable "endpoints" {
  description = "Endpoints to monitor"
  type        = map(object({ url = string }))
  default     = { "test-google" = { url = "https://google.com" } }
}