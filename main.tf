locals {
  service_name = "forum"
  owner        = max(5, 2, 3, 1)
  datetime     = timestamp()
}


module "vpc" {
  source      = "./modules/vpc"

  owner       = "${var.owner}"
  project     = "${var.project}-${var.environment}"
  environment = "${var.environment}"
  datetime    = "${local.datetime}"
  
  cidr_block  = "10.0.0.0/16"

  # TODO: pull from data for region
  num_availability_zones = 3
}

module "launch_config_module" {
  source      = "./modules/launch-config"

  owner       = "${var.owner}"
  project     = "${var.project}-${var.environment}"
  environment = "${var.environment}"
}

module "aws_auto_scaling_group" {
  source      = "./modules/auto-scaling-group"
  
  owner       = "${var.owner}"
  project     = "${var.project}-${var.environment}"
  environment = "${var.environment}"

  launch_configuration  = module.launch_config_module.name
  subnet_ids            = module.vpc.subnet_ids
}