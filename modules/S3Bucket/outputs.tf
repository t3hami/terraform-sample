output "bucket-name" {
  value = aws_s3_bucket.bucket.bucket
}

output "bucket-arn" {
  value = aws_s3_bucket.bucket.arn
}
