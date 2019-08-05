provider "aws" {
  version = "~> 2.0"
  region  = "${lookup(var.region, local.env)}"
  shared_credentials_file = "/Users/melontron/.aws/credentials"
  profile = "default-playground"
}

locals {
  env = "${terraform.workspace}"
}
