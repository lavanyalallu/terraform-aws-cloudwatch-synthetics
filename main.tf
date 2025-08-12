# Managed By : CloudDrove
# Description : This Script is used to create Cloudwatch Alarms.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  name        = var.name
  environment = var.environment
  repository  = var.repository
  managedby   = var.managedby
  label_order = var.label_order
}

#Module      : CLOUDWATCH SYNTHETIC CANARY
#Description : Terraform module creates Cloudwatch Synthetic canaries on AWS for monitoriing Websites.

locals {
  file_content = { for k, v in var.endpoints :
    k => templatefile("${path.module}/canary-lambda.js.tpl", {
      endpoint = v.url
    })
  }
}

data "archive_file" "canary_archive_file" {
  for_each    = var.endpoints
  type        = "zip"
  output_path = "/tmp/${each.key}-${md5(local.file_content[each.key])}.zip"

  source {
    content  = local.file_content[each.key]
    filename = "nodejs/node_modules/pageLoadBlueprint.js"
  }
}

resource "aws_synthetics_canary" "canary" {
  for_each            = var.endpoints
  name                = each.key
  artifact_s3_location = var.existing_s3_bucket_name != "" ? "s3://${var.existing_s3_bucket_name}/${each.key}" : "s3://${module.internal_s3.s3_bucket_id}/${each.key}"
  execution_role_arn  = aws_iam_role.canary_role.arn
  handler             = "pageLoadBlueprint.handler"
  zip_file            = "/tmp/${each.key}-${md5(local.file_content[each.key])}.zip"
  runtime_version     = "syn-nodejs-puppeteer-6.2"
  start_canary        = true
  tags                = module.labels.tags

  schedule {
    expression = var.schedule_expression
  }

  vpc_config {
    subnet_ids        = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  depends_on = [
    data.archive_file.canary_archive_file,
    aws_iam_role_policy_attachment.canary_role_policy,
  ]
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid    = "AllowCloudWatchSyntheticsAccess"
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.canary_role.arn]
    }
    actions   = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${module.internal_s3.s3_bucket_id}",
      "arn:aws:s3:::${module.internal_s3.s3_bucket_id}/*"
    ]
  }
}

module "internal_s3" {
  source        = "./modules/s3"
  bucket_name   = var.s3_artifact_bucket
  force_destroy = true
  tags          = module.labels.tags
  bucket_policy = data.aws_iam_policy_document.s3_bucket_policy.json
}



