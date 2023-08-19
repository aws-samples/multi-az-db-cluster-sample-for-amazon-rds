variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
}

variable "subnet_count" {
  description = "Number of subnets to create"
}

variable "subnet_cidr" {
  type        = list(string)
  description = "List of subnet CIDR blocks"
}

variable "security_group_name" {
  description = "Name for the security group"
}
