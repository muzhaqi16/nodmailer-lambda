variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "domain" {
  description = "Domain that emails are sent from"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

variable "bucket_name" {
  default = "node-mailer-lambda-bucket"
}

variable "acl_value" {
  default = "private"
}

variable "from_email" {
  description = "Email address that emails are sent from based on your verified SES domain"
  type        = string
  default     = "contact"
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "NodeMailer"
}

variable "env" {
  description = "Environment for all resources."
  type        = string
  default     = "dev"
}
