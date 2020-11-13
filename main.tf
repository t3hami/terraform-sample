##################################################################################
# Provider
##################################################################################

//If credentials are passed through profile
provider "aws" {
  region     = "us-east-1"
  profile = "aws-credentials"
}

//If credentials are passed through "Environment" to "terraform.tfvars" file
//provider "aws" {
//  access_key = var.aws_access_key
//  secret_key = var.aws_secret_key
//  region     = var.aws_region
//}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Environment    = var.Environment
    Terraform      = "True"
    TerraformState = "${var.Name}/${var.Environment}"
    Name           = var.Name
  }
  common_name = "${lower(var.Name)}-${lower(var.Environment)}"
}

##################################################################################
# Lambda
##################################################################################

//module is called
module "lambda" {
  source = "./modules/LambdaFunction"
  common_prefix = "${local.common_name}-createFileInS3"
  runtime = "nodejs12.x"
  function_handler = "lambda.handler"
  common_tags = local.common_tags
  source_code_folder_path = "Lambdas/CreateFileInS3"
  memory_size = 256
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "s3:GetObject"
        ],
        "Resource": "arn:aws:s3:::test-s3-boto3/*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:PutObject"
        ],
        "Resource": "arn:aws:s3:::test-s3-boto3/*"
    }
  ]
}
EOF
  environment_variables = merge(
  { bucket = aws_s3_bucket.bucket.id },
  { filename = "testfile" }
  )
}

##################################################################################
# S3 bucket
##################################################################################

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${local.common_name}-bucket"
  tags          = local.common_tags
  force_destroy = true
}

##################################################################################
# CloudWatch Event Trigger To Lambda
##################################################################################

//module is called
module "cloud_watch_lambda_trigger" {
  source = "./modules/CloudWatchLambdaEvent"
  name = "${local.common_name}-cloud_watch_lambda_trigger"
  target_arn = module.lambda.arn
  rate = "60"//60 min
  common_tags = local.common_tags
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"

  function_name = module.lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = module.cloud_watch_lambda_trigger.cloudwatch_event_rule_arn
}

##################################################################################
# DynamoDB Tables
##################################################################################

locals {
  dynamodb_tables_list = ["Table1","Table2","Table3","Table4"]
}

resource "aws_dynamodb_table" "dynamodb_table" {
  count = length(local.dynamodb_tables_list)
  name             = local.dynamodb_tables_list[count.index]
  hash_key         = "id"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "id"
    type = "S"
  }

  tags = local.common_tags
}