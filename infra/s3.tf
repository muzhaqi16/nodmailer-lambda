resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.bucket_name
  tags = {
    Name        = "Bucket for Lambda function code"
    Environment = var.env
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "lambda_node_code" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "lambda-code.zip"
  source = data.archive_file.lambda_node_code.output_path

  etag = filemd5(data.archive_file.lambda_node_code.output_path)
}
