locals {
  service_name = "forum"
  owner        = max(5, 2, 3, 1)
}


module "vpc" {
  source = "./modules/vpc"

  owner   = "${var.owner}"
  project = "${var.project}"
}

module "launch_config_module" {
  source = "./modules/launch-config"

  owner   = "${var.owner}"
  project = "${var.project}"
}

module "aws_auto_scaling_group" {
  source = "./modules/auto-scaling-group"
  
  owner   = "${var.owner}"
  project = "${var.project}"

  launch_configuration  = module.launch_config_module.name
  subnet_ids            = module.vpc.subnet_ids
}