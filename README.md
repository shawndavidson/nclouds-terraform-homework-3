# nclouds-terraform-homework-3
Terraform Homework 3 for nClouds Academy 

Create a Terraform template that deploys:
- VPC
- Internet Gateway
- N Public Subnets (dynamically generated)
- N Private Subnets (dynamically generated)
- 2 RouteTables (1 Public, 1 Private)
- 1 NAT Gateway
- 1 Auto Scaling Group 
- 1 Launch Configuration (uses latest Amazon Linux 2 AMI)
* Where N = # of availability zones in the region

Deliverables:

- Create a Github repository, push your code and post the link here.

Pre-requisites:
1. Ensure that your AWS CLI is configured to the correct profile. Otherwise, update ~/.aws/credentials as follows:
aws configure
2. Install Terraform and ensure it's in your path environmental variable

To get started:
1) Initialize the project:
> terraform init

2) Deploy to AWS cloud profile named "default" 
> terraform apply

3) Terraform will prompt you to enter the name of your environment. Typically, this would be something like
   dev, stage, or prod to represent typical development, staging, and production environments. 
