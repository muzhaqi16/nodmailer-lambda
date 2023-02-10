resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      # Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })

  tags = {
    Name = "node-mailer-lambda-role"
  }
}

# Provides write permissions to CloudWatch Logs. AWS Managed Policy
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_policy" "nodemailer_ses_transport" {
  name        = "nodemailer_ses_transport"
  description = "Nodemailer SES Transport Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "ses:SendRawEmail",
        "ses:SendEmail",
        "ses:SendTemplatedEmail",
        "ses:SendBulkTemplatedEmail",
        "ses:SendBulkEmail"
      ]
      Effect   = "Allow"
      Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "nodemailer_ses_transport" {
  name       = "nodemailer_ses_transport"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = aws_iam_policy.nodemailer_ses_transport.arn
}
