This will create the lambda function

To deploy the infrastructure run. You need to setup the aws cli before deploying using `aws configure`

`terraform apply`

After the infrastructure and the code is deployed you can invoke the function using the line below.

`aws lambda invoke --region=us-east-1 --function-name=$(terraform output -raw function_name) response.json --cli-binary-format raw-in-base64-out --payload file://payload.json`

To pass parameters to the function use:

And to save the response locally use:

`--cli-binary-format raw-in-base64-out --payload file://payload.json`
