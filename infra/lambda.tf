data "archive_file" "lambda_node_code" {
  type = "zip"

  source_dir  = "${path.module}/../code"
  output_path = "${path.module}/../lambda-code.zip"
}

resource "aws_lambda_function" "function" {
  function_name = var.function_name

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_node_code.key

  runtime = "nodejs16.x"
  #   needs to match the file name in the zip file that contains the handler function
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_node_code.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
  # set execution timeout to 10 seconds
  timeout = 5

  environment {
    variables = {
      ENV          = "prod",
      FROM_ADDRESS = "${join("@", [var.from_email, var.domain])}"
    }
  }

  depends_on = [
    aws_s3_object.lambda_node_code
  ]

}

