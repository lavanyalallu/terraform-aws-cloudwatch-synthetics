# # Canary IAM Role Trust Policy
# data "aws_iam_policy_document" "trust_policy" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#   }
# }

# # Canary Permissions Policy
# data "aws_iam_policy_document" "canary_permissions" {
#   statement {
#     sid    = "S3Access"
#     effect = "Allow"
#     actions = [
#       "s3:PutObject",
#       "s3:GetObject"
#     ]
#     resources = [
#       "arn:aws:s3:::${var.s3_artifact_bucket}/*"
#     ]
#   }

#   statement {
#     sid    = "S3GetBucketLocation"
#     effect = "Allow"
#     actions = [
#       "s3:GetBucketLocation"
#     ]
#     resources = [
#       "arn:aws:s3:::${var.s3_artifact_bucket}"
#     ]
#   }

#   statement {
#     sid    = "CloudWatchLogsAccess"
#     effect = "Allow"
#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents"
#     ]
#     resources = [
#       "arn:aws:logs:*:*:log-group:/aws/lambda/cwsyn-*"
#     ]
#   }

#   statement {
#     sid    = "S3ListAndXrayAccess"
#     effect = "Allow"
#     actions = [
#       "s3:ListAllMyBuckets",
#       "xray:PutTraceSegments"
#     ]
#     resources = ["*"]
#   }

#   statement {
#     sid    = "CloudWatchMetricAccess"
#     effect = "Allow"
#     actions = ["cloudwatch:PutMetricData"]
#     resources = ["*"]

#     condition {
#       test     = "StringEquals"
#       variable = "cloudwatch:namespace"
#       values   = ["CloudWatchSynthetics"]
#     }
#   }

#   statement {
#     sid    = "ENIAccess"
#     effect = "Allow"
#     actions = [
#       "ec2:CreateNetworkInterface",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DeleteNetworkInterface"
#     ]
#     resources = ["*"]
#   }
# }

# # IAM Module Invocation for Canary Role
# module "canary_access" {
#   source = ""

#   name       = var.name
#   namespace  = var.namespace

#   trust_policy     = data.aws_iam_policy_document.trust_policy.json
#   policy_documents = [data.aws_iam_policy_document.canary_permissions.json]

#   tags = merge(local.tags, { parent = local.id_tag.iac_identifier })
# }
