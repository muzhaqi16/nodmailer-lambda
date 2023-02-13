# Output value definitions

output "node_mailer_bucket" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}
# Function name is being output so that it can be used in the cloudwatch.tf file for logs
output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.function.function_name
}
