##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {}

##################################################################################
# LOCALS
##################################################################################

locals {

  common_tags = var.common_tags

}

##################################################################################
# DATA
##################################################################################

# AWS
data "aws_caller_identity" "target-account-identity" {
}

data "aws_region" "region" {
}


##################################################################################
# RESOURCES
##################################################################################

# Static site

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = var.bucket_prefix
  tags          = local.common_tags
  force_destroy = true
}

resource "aws_s3_bucket_policy" "website_hosting-bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource":  [
          "${aws_s3_bucket.bucket.arn}/*"
        ],
        "Principal": "*"
      }

    ]
  }
  POLICY
}


