# Nodemailer AWS lambda with Terraform

This code create the ifrastructure and deploys a lambda function to AWS that sends emails using nodemailer and SES.

---

## Table of Contents

- [Installation](#installation)
- [Environment Variables](#environment)
- [Deployment](#deployment)
- [Demo](#demo)
- [Resources](#resources)
- [Author](#authors)

---

## Installation

Before deploying you will need:

- [AWS cli](https://aws.amazon.com/cli/)
  - After installing run `aws configure` and provide the necessary info
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

You also need to have a domain configured in route_53 before deploying.

---

## Environment Variables

To run this project, you will need to add the following environment variables to your `terraform.tfvars` file

- Required

  `domain`

  `hosted_zone_id`

---

## Deployment

To deploy this project run

```bash
  terraform apply
```

---

## Demo

After the infrastructure and the code is deployed you can invoke the function using the line below.

`aws lambda invoke --region=us-east-1 --function-name=NameOfFunction`

To pass parameters to the function use:

`--cli-binary-format raw-in-base64-out --payload file://payload.json`

And to save the response locally pass the name of the file to save it at after the function name:

`...=NameOfFunction response.json`

To get the terraform function name automatically run:

`=$(terraform output -raw function_name)`

For a full example you based on this forlder structure you can run

```
aws lambda invoke
--region=us-east-1
--function-name=$(cd infra && terraform output -raw function_name) response.json --cli-binary-format raw-in-base64-out
--payload file://payload.json

```

---

## Resources

Useful terraform commands

To see the resources that will be created and if you are satisfied then run:

`terraform plan`

To create the infra and deploy the code

`terraform apply`

To delete all the resources created run:

`terraform destroy`

---

## Authors

- [@muzhaqi16](https://github.com/muzhaqi16)
