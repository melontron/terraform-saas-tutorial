
variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR for the Public Subnet"
  type = list
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR for the Private Subnet"
  type = "list"
  default = ["10.0.2.0/24","10.0.3.0/24"]
}

variable "project" {
  description = "Project to add to Terraform tags"
}



variable "nat_instance_id" {
  description = "NAT instance id to connect private subnets to"
}
variable "env" {}
