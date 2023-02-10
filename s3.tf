resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.bucket_name
  tags = {
    Name        = "Lambda to send emails"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "lambda_node_mailer" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "node-mailer.zip"
  source = data.archive_file.lambda_node_mailer.output_path

  etag = filemd5(data.archive_file.lambda_node_mailer.output_path)
}
