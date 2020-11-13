##################################################################################
# VARIABLES
##################################################################################

variable "common_tags" {
  type = map(string)
}

variable "target_arn" {
}

variable "name" {
  default = "my-cloudwatch-event"
}

variable "rate" {
  //minutes
  default = "360"
}