locals {
  service_name = "forum"
  owner        = max(5, 2, 3, 1)
  datetime     = timestamp()
  project-env  = "${var.project}-${var.environment}"
}


module "vpc" {
  source      = "./modules/vpc"

  owner       = "${var.owner}"
  project     = "${local.project-env}"  
  environment = "${var.environment}"
  datetime    = "${local.datetime}"
  
  cidr_block  = "${var.cidr_block}"
}

module "launch_config_module" {
  source      = "./modules/launch-config"

  owner       = "${var.owner}"
  project     = "${local.project-env}"  
  environment = "${var.environment}"
}

module "aws_auto_scaling_group" {
  source      = "./modules/auto-scaling-group"
  yes
  owner       = "${var.owner}"
  project     = "${local.project-env}" 
  environment = "${var.environment}"

  launch_configuration  = module.launch_config_module.name
  subnet_ids            = module.vpc.subnet_ids
}