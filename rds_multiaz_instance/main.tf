provider "aws" {
  region = var.region
}

#########################
# Create Unique password
#########################
resource "random_password" "master"{
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  name = var.rds_secret_name
  kms_key_id = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}


#########
# Locals
#########

locals {
  name   = var.name
  region = var.region

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source                                      = "../modules/rds_modules/rds_vpc"

  name                                        = local.name
  cidr                                        = var.vpccidr

  azs                                         = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets                             = slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_count)
  public_subnets                              = slice(var.public_subnet_cidr_blocks, 0, var.public_subnet_count)
  database_subnets                            = slice(var.database_subnet_cidr_blocks, 0, var.database_subnet_count)

  private_subnet_names                        = ["Private Subnet One", "Private Subnet Two" , "Private Subnet Three"]
  # public_subnet_names omitted to show default name generation for all three subnets
  database_subnet_names                       = ["DB Subnet One", "DB Subnet Two" , "DB Subnet Three"]

  create_database_subnet_group                = var.create_database_subnet_group

  manage_default_network_acl                  = var.manage_default_network_acl
  default_network_acl_tags                    = { Name = "${local.name}-default" }

  manage_default_route_table                  = var.manage_default_route_table
  default_route_table_tags                    = { Name = "${local.name}-default" }

  manage_default_security_group               = var.manage_default_security_group
  default_security_group_tags                 = { Name = "${local.name}-default" }

  enable_dns_hostnames                        = var.enable_dns_hostnames
  enable_dns_support                          = var.enable_dns_support

  enable_nat_gateway                          = var.enable_nat_gateway
  single_nat_gateway                          = var.single_nat_gateway

  enable_vpn_gateway                          = var.enable_vpn_gateway

  enable_dhcp_options                         = var.enable_dhcp_options
  dhcp_options_domain_name                    = "service.consul"
  dhcp_options_domain_name_servers            = ["127.0.0.1", "10.10.0.2"]

  tags                                        = local.tags
}

################################################################################
# Subnet Group from Module
################################################################################
module "subnet_group" { 
  source                                      = "../modules/rds_modules/rds_db_subnet_group"
  name                                        = local.name
  subnet_ids                                  = module.vpc.private_subnets
}

################################################################################
# Cluster Parameter Group from Module
################################################################################

data "aws_rds_engine_version" "family" {
  engine   = var.engine
  version  = var.engine == "postgres" ? var.engine_version_pg : var.engine_version_mysql
}


module "db_parameter_group" {
  source                                      = "../modules/rds_modules/rds_db_parameter_group"
  name                                        = local.name
  family                                      = data.aws_rds_engine_version.family.parameter_group_family
}

################################################################################
# RDS Multi-AZ DB Instance Module
################################################################################

module "db" {
  source                                      = "../modules/rds_modules/rds_db_instance"

  identifier                                  = "${local.name}"

  engine                                      = var.engine
  engine_version                              = var.engine == "postgres" ? var.engine_version_pg : var.engine_version_mysql
  
  instance_class                              = var.instance_class
  allocated_storage                           = var.allocated_storage
  max_allocated_storage                       = var.max_allocated_storage

  db_name                                     = var.db_name
  username                                    = var.username
  port                                        = var.port == "" ? var.engine == "postgres" ? "5432" : "3306" : var.port
  password                                    = (var.snapshot_identifier != "") ? null : (var.password == "" ? aws_secretsmanager_secret.password.id : var.password)

  parameter_group_name                        = module.db_parameter_group.db_parameter_group_id
  multi_az                                    = var.multi_az

  db_subnet_group_name                       = module.subnet_group.db_subnet_group_id
  vpc_security_group_ids                     = [module.vpc.default_security_group_id]

  maintenance_window                          = var.maintenance_window
  backup_window                               = var.backup_window
  enabled_cloudwatch_logs_exports             = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group                 = var.create_cloudwatch_log_group

  backup_retention_period                     = var.backup_retention_period
  skip_final_snapshot                         = var.skip_final_snapshot
  deletion_protection                         = var.deletion_protection

  performance_insights_enabled                = var.performance_insights_enabled
  performance_insights_retention_period       = var.performance_insights_retention_period
  create_monitoring_role                      = var.create_monitoring_role
  monitoring_interval                         = var.monitoring_interval
  monitoring_role_name                        = var.monitoring_role_name
  monitoring_role_use_name_prefix             = var.monitoring_role_use_name_prefix
  monitoring_role_description                 = var.monitoring_role_description

}


