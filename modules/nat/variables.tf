variable "project" {
  description = "Project to add to Terraform tags"
}
variable "env" {}

variable "vpc_id" {
  description = "Id of the vpc to deploy in"
}

variable "public_subnet_cidrs" {
  description = "CIDR for the Public Subnet"
  type = list
}

variable "private_subnet_cidrs" {
  description = "CIDR for the Private Subnet"
  type = "list"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
}

variable "nat_instnace_subnet" {
  description = "Subnet id of nat instance"
}
variable "aws_key_path" {
  description = "aws key path used for remote exec"
}

variable "elasticache_host" {
  description = "Elastcache endpoint used for digging cluster node private IP address and then setting up NAT"
}
variable "elasticache_port" {
  description = "Elastcache port used for digging cluster node private IP address and then setting up NAT"
}

variable "aws_key_name" {}

variable "assign_eip" {
  default = 0
  description = "Weather to assign elastic ip address to nat instance or not"
}

variable "shutdown_after_setup" {
  default = 0
  description = "Weather to turn off the instance after creation or not"
}
