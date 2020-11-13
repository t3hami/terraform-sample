output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "role_id" {
  value = aws_iam_role.lambda_role.id
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.lambda_log_group.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}