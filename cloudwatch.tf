resource "aws_cloudwatch_log_group" "node_mailer" {
  name = "/aws/lambda/${aws_lambda_function.node_mailer.function_name}"

  retention_in_days = 7
}
