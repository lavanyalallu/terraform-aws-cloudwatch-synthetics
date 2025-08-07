output "canary_names" {
  description = "Names of created canaries"
  value       = [for k in keys(module.canaries.endpoints) : k]
}

output "canary_arns" {
  description = "ARNs of created canaries"
  value       = module.canaries.canary_arns
}

output "s3_artifact_bucket_name" {
  description = "Name of the S3 bucket used for canary artifacts"
  value       = var.s3_artifact_bucket
}