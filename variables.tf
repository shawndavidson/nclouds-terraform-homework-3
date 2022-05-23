variable "project" {
  type        = string
  default     = "sdavidson-terraform"
  description = "Type here the project name"
}

variable "owner" {
  type        = string
  default     = "sdavidson"
  description = "Type here the owner of the project"
}

variable "environment" {
  type        = string
  description = "Type here the environment of the project (dev/stage/prod)"
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Type the CIDR block for your VPC, e.g. 10.0.0.0/16"
}