#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  description = "Name  of the application"
  default     = "cwsyn"
}

variable "repository" {
  type        = string
  description = "Name of the repository"
  default     = "cloudwatch-synthetics"
}

variable "environment" {
  type        = string
  description = "Environment of the application"
  default     = "test"
}

variable "label_order" {
  type        = list(string)
  description = "Set label order"
  default     = ["name", "environment"]
}

variable "managedby" {
  type        = string
  description = "Managed By"
  default     = "CloudDrove"
}

#Module      : Synthetic canaries
#Description : Terraform Synthetic canaries module variables.

variable "s3_artifact_bucket" {
  type        = string
  description = "Name of the S3 bucket for canary artifacts"
}

variable "schedule_expression" {
  type        = string
  description = "Cron expression for the canary"
  default     = "rate(5 minutes)"
}

variable "endpoints" {
  type = map(object({
    url = string
  }))
  description = "Map of endpoints to monitor"
}

variable "alarm_email" {
  type        = string
  description = "Email address to send alarms to"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for VPC configuration (optional)"
  default     = []
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for VPC configuration (optional)"
  default     = []
}

variable "existing_s3_bucket_name" {
  type        = string
  description = "Name of an existing S3 bucket to use for artifacts (optional)"
  default     = ""
}