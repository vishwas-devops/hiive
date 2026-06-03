data "datadog_integration_aws_iam_permissions" "datadog_permissions" {}

locals {
  datadog_permissions = data.datadog_integration_aws_iam_permissions.datadog_permissions.iam_permissions
}

data "aws_iam_policy_document" "datadog_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::<account-id>:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        datadog_integration_aws_account.aws.auth_config.aws_auth_config_role.external_id
      ]
    }
  }
}

data "aws_iam_policy_document" "datadog_policy" {
  statement {
    actions   = local.datadog_permissions
    resources = ["*"]
  }
}

resource "aws_iam_policy" "datadog_policy" {
  name   = "DatadogAWSIntegrationPolicy"
  policy = data.aws_iam_policy_document.datadog_policy.json
}

resource "aws_iam_role" "datadog_role" {
  name               = "DatadogIntegrationRole"
  assume_role_policy = data.aws_iam_policy_document.datadog_assume_role.json
}

resource "aws_iam_role_policy_attachment" "datadog_policy_attachment" {
  role       = aws_iam_role.datadog_role.name
  policy_arn = aws_iam_policy.datadog_policy.arn
}

resource "aws_iam_role_policy_attachment" "datadog_security_audit" {
  role       = aws_iam_role.datadog_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "datadog_integration_aws_account" "aws" {
  aws_account_id = var.aws_account_id
  aws_partition  = "aws"

  aws_regions {
    include_all = true
  }

  auth_config {
    aws_auth_config_role {
      role_name = aws_iam_role.datadog_role.name
    }
  }

  resources_config {
    cloud_security_posture_management_collection = false
    extended_collection                          = true
  }

  metrics_config {
    namespace_filters {}
  }

  traces_config {
    xray_services {}
  }

  logs_config {
    lambda_forwarder {}
  }

  account_tags = [
    "env:${var.environment}",
    "platform:hiive"
  ]
}
