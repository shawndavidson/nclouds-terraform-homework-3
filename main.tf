locals {
  service_name = "forum"
  owner        = max(5, 2, 3, 1)
}


module "vpc" {
  source = "./modules/vpc"

  owner   = "sdavidson"
  project = "sdavidson-terraform"
}