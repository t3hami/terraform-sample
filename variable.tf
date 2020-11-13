##################################################################################
# VARIABLES
##################################################################################

variable "Name" {
  default = "Test"
}

variable "Environment" {
  default = "Dev"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {}