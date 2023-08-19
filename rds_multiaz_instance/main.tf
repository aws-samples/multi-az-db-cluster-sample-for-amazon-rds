provider "aws" {
  region = var.region
}

#########################
# Create Unique password
#########################
resource "random_password" "master"{
  length           = 10
  special          = false
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

  vpc_name                                        = local.name
  vpc_cidr                                    = var.vpccidr
  subnet_count                                = var.subnet_count
  subnet_cidr                                 = var.subnet_cidr
  security_group_name                         = local.name
}

################################################################################
# Subnet Group from Module
################################################################################
module "subnet_group" { 
  source                                      = "../modules/rds_modules/rds_db_subnet_group"
  name                                        = local.name
  subnet_ids                                  = module.vpc.subnet_ids
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
  vpc_security_group_ids                     = [module.vpc.db_security_group_id]

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


