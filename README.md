This code create the ifrastructure and deploys a lambda function to AWS that sends emails using nodemailer and SES.

Before starting please install:

- [AWS cli](https://aws.amazon.com/cli/)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

To deploy the infrastructure first you need to setup the aws cli before deploying using `aws configure`

After than run

`terraform plan`

to see the resources that will be created and if you are satisfied then run:

`terraform apply`

To delete all the resources created run:

`terraform destroy`

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
--function-name=$(cd infra && terraform output -raw function_name) response.json --cli-binary-format raw-in-base64-out --payload file://payload.json

```
