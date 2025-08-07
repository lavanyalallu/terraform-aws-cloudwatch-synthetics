provider "aws" {
  region = var.region
}

module "canaries" {
  source              = "../.."
  name                = var.name
  environment         = var.environment
  label_order         = var.label_order
  schedule_expression = var.schedule_expression
  s3_artifact_bucket  = var.s3_artifact_bucket
  alarm_email         = var.alarm_email
  endpoints           = var.endpoints
  # subnet_ids         = module.subnets.private_subnet_id
  # security_group_ids = [module.ssh.security_group_ids]
}

resource "random_pet" "suffix" {
  length = 2
}