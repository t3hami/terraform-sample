##################################################################################
# VARIABLES
##################################################################################

variable "common_prefix" {
  default = "myfunction"
}

variable "common_tags" {
  type = map(string)
}

variable "source_code_folder_path" {
}

variable "function_handler" {
}

variable "timeout" {
  default = 300
}

variable "environment_variables" {
  type = map(string)
}

variable "runtime" {
}

variable "policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:GetLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF

}

variable "memory_size" {
  default = 128
}

variable "description" {
  default = ""
}

variable "reserved_concurrent_executions" {
  default = -1
}
