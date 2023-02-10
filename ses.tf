# SES Domain Identity
resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.domain
}
#SES Email Identity
resource "aws_ses_email_identity" "domain" {
  email = "contact@${var.domain}"
}
resource "aws_ses_domain_mail_from" "main" {
  domain           = aws_ses_domain_identity.ses_domain.domain
  mail_from_domain = "mail.${var.domain}"
}
resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  domain = aws_ses_domain_identity.ses_domain.domain
}

resource "aws_ses_domain_identity_verification" "example_verification" {
  domain = aws_ses_domain_identity.ses_domain.id

  depends_on = [aws_route53_record.amazonses_verification_record]
}
