data "archive_file" "lambda_node_mailer" {
  type = "zip"

  source_dir  = "${path.module}/node-mailer"
  output_path = "${path.module}/node-mailer.zip"
}

resource "aws_lambda_function" "node_mailer" {
  function_name = "NodeMailer"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_node_mailer.key

  runtime = "nodejs16.x"
  #   needs to match the file name in the zip file that contains the handler function
  handler = "sendMail.handler"

  source_code_hash = data.archive_file.lambda_node_mailer.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
  # set execution timeout to 10 seconds
  timeout = 5

  environment {
    variables = {
      env = "prod"
    }
  }
}

