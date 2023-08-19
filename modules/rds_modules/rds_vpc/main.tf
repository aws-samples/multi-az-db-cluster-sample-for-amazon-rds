resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "my_subnet" {
  count = var.subnet_count

  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr[count.index]

  tags = {
    Name = "${var.vpc_name}-subnet-${count.index}"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = var.security_group_name
  description = "Security group for ${var.vpc_name}"

  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = var.security_group_name
  }
}