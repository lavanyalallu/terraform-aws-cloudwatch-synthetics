output "canary_arns" {
  description = "ARNs of created canaries"
  value       = { for k, v in aws_synthetics_canary.canary : k => v.arn }
}

output "endpoints" {
  description = "Endpoints monitored"
  value       = var.endpoints
}