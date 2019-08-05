variable "project" {
  type = "map"
  default = {
    dev = "brendly"
    stage = "brendly"
    prod = "brendly"
  }
  description = "The name of the project that will live in infrastructure, it is used for prefixing"
}

variable "region" {
  type = "map"
  default = {
    dev = "us-east-1"
    stage = "us-east-1"
    prod = "us-east-1"
  }
  description = "regoin of the deployment"
}
