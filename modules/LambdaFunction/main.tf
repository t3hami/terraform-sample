locals {
  # Common tags to be assigned to all resources
  common_tags = var.common_tags
  environment_variables = merge(
    {
      "ModuleDeployment" = "true"
    },
    var.environment_variables,
  )
}

data "aws_caller_identity" "target-account-identity" {
}

resource "aws_iam_role_policy" "lambda_logging_policy" {
  name   = "${var.common_prefix}-logging_policy"
  role   = aws_iam_role.lambda_role.id
  policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
              ],
              "Resource": "${aws_cloudwatch_log_group.lambda_log_group.arn}*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "xray:*"
              ],
              "Resource": "*"
          }
      ]
  }
  EOF

}

resource "aws_iam_role_policy" "lambda_policy" {
  role   = aws_iam_role.lambda_role.id
  policy = var.policy
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.common_prefix}-role"
  assume_role_policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                  "Service": "lambda.amazonaws.com"
              },
              "Action": "sts:AssumeRole"
          }
      ]
  }
  EOF
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.common_prefix}"
  retention_in_days = 90
  tags              = local.common_tags
}

resource "random_string" "random" {
  length  = 16
  special = false
  keepers = {
    timestamp = timestamp()
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_code_folder_path
  output_path = "${var.source_code_folder_path}/../${random_string.random.result}.zip"
}

resource "aws_lambda_function" "lambda" {
  depends_on = [
    aws_iam_role_policy.lambda_logging_policy
  ]
  function_name                  = var.common_prefix
  role                           = aws_iam_role.lambda_role.arn
  tags                           = local.common_tags
  description                    = var.description
  reserved_concurrent_executions = var.reserved_concurrent_executions
  filename                       = data.archive_file.lambda_zip.output_path
  source_code_hash               = data.archive_file.lambda_zip.output_base64sha256
  handler                        = var.function_handler
  runtime                        = var.runtime
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  tracing_config {
    mode = "Active"
  }
  environment {
    variables = local.environment_variables
  }
}



