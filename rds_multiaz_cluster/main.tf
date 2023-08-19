provider "aws" {
  region = var.region
}

#########################
# Create Unique password
########################

resource "random_password" "master"{
  length           = 4
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

  vpc_name                                    = local.name
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
# Option Group from Module not supported in PostgreSQL
################################################################################

data "aws_rds_engine_version" "family" {
  engine   = var.engine
  version  = var.engine == "postgres" ? var.engine_version_pg : var.engine_version_mysql
}

################################################################################
# Cluster Parameter Group from Module
################################################################################
module "db_cluster_parameter_group" {
  source                                      = "../modules/rds_modules/rds_db_parameter_group"
  name                                        = local.name
  family                                      = data.aws_rds_engine_version.family.parameter_group_family
}
################################################################################
# RDS Multi-AZ DB Cluster Module
################################################################################

module "db_cluster" {
  source                                      = "../modules/rds_modules/rds_db_cluster"
  
  cluster_identifier                          = "${local.name}"
  
  engine                                      = var.engine
  engine_version                              = var.engine == "postgres" ? var.engine_version_pg : var.engine_version_mysql
 
  db_cluster_instance_class                   = var.db_cluster_instance_class

  db_cluster_parameter_group_name             = module.db_cluster_parameter_group.cluster_parameter_group_id

  allocated_storage                           = var.allocated_storage
  iops                                        = var.iops
  storage_type                                = var.storage_type

  database_name                               = var.database_name
  master_username                             = var.master_username
  port                                        = var.port == "" ? var.engine == "postgres" ? "5432" : "3306" : var.port
  master_password                             = (var.snapshot_identifier != "") ? null : (var.master_password == "" ? aws_secretsmanager_secret.password.id : var.master_password)

  snapshot_identifier                         = var.snapshot_identifier

  db_subnet_group_name                        = module.subnet_group.db_subnet_group_id
  vpc_security_group_ids                      = [module.vpc.db_security_group_id]

  preferred_maintenance_window                = var.preferred_maintenance_window
  preferred_backup_window                     = var.preferred_backup_window
  enabled_cloudwatch_logs_exports             = var.enabled_cloudwatch_logs_exports
 

  backup_retention_period                     = var.backup_retention_period
  skip_final_snapshot                         = var.skip_final_snapshot
  deletion_protection                         = var.deletion_protection

  }

