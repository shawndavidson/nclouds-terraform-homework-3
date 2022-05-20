# Module: launch_config
# This purpose of this module is to declare an AWS launch configuration for use by an Auto-Scaling Group
# It uses the latest Amazon Linux 2 HVM AMI.

# See https://www.hashicorp.com/blog/hashicorp-terraform-supports-amazon-linux-2
data "aws_ami" "amazon-linux-2" {
 most_recent = true

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }

 filter {
   name   = "name"
   values = ["amzn2-ami-kernel*"]
 }

   owners = ["amazon"] 
}

resource "aws_launch_configuration" "launch_config" {
# Allows Terraform to name the resource for us, avoiding issues with updating the auto scaling
# group because it normally has to destory the launch config before recreating the new one. Must 
# also set create_before_destroy to true - see below)
  name_prefix     = "${var.project}-launch-config"
  image_id        = "${data.aws_ami.amazon-linux-2.id}"
  instance_type   = "t2.micro"

# See comment above regarding name_prefix
  lifecycle {
    create_before_destroy = true
  }
}

