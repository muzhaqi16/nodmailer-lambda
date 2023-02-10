variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "domain" {
  description = "Domain that emails are sent from"
  type        = string
}

variable "hosted_zone_domain" {
  description = "Route 53 Hosted Zone domain"
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
