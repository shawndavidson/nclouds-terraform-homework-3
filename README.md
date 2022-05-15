# nclouds-terraform-homework1-1
Terraform Homework 1 for nClouds Academy 

Create a Terraform template that deploys:
- VPC
- Internet Gateway
- 3 Public Subnets
- 3 Private Subnets
- 2 RouteTables (1 Public, 1 Private)
- NAT Gateway

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
