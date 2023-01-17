variable "region" {
  description = "Mention the refion you want to deploy the resources"
  type        = string
  default     = "us-west-2"
}

variable "name" {
  description = "Prefix for the resources"
  type        = string
  #default     = null
}

variable "rds_secret_name" {
  description = "RDS Secret name for the RDS resources"
  type        = string
}

variable "vpccidr" {
  description = "CIDR for creating the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
  default     = 3
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 3
}

variable "database_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 3
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
  ]
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24",
  ]
}

variable "database_subnet_cidr_blocks" {
  description = "Available cidr blocks for Databases subnets."
  type        = list(string)
  default     = [
    "10.0.201.0/24",
    "10.0.202.0/24",
    "10.0.203.0/24",
    "10.0.204.0/24",
    "10.0.205.0/24",
    "10.0.206.0/24",
    "10.0.207.0/24",
    "10.0.208.0/24",
  ]
}

variable "create_database_subnet_group" {
  description = "Create database subnet group"
  type        = bool
  default     = true
}

variable "manage_default_network_acl" {
  description = "Create NCL"
  type        = bool
  default     = true
}

variable "manage_default_route_table" {
  description = "Create Default route table"
  type        = bool
  default     = true
}

variable "manage_default_security_group" {
  description = "Create Default security group"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS Hostnames"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS Support"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Enable Single NAT Gateway"
  type        = bool
  default     = false
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway"
  type        = bool
  default     = false
}

variable "enable_dhcp_options" {
  description = "Enable VPN Gateway"
  type        = bool
  default     = false
}

###Database

variable "engine" {
  description = "Enter the engine name either postgres or mysql ( MAZ Cluster Supported)"
  type        = string
  default     = "postgres"
}

variable "engine_version_pg" {
  description = "PostgreSQL database engine version."
  type        = string
  default     = "13.4"
}

variable "engine_version_mysql" {
  description = "MySQL database engine version."
  type        = string
  default     = "8.0.30"
}


variable "db_cluster_instance_class" {
  description = "RDS Instance class"
  type        = string
  default     = "db.m6gd.large"
}


variable "allocated_storage" {
  description = "RDS Allocated Storage"
  type        = number
  default     = 100
}


variable "iops" {
  description = "RDS Storage IOPS"
  type        = number
  default     = 1000
}

variable "storage_type" {
  description = "RDS Storage Iops"
  type        = string
  default     = "io1"
}

variable "max_allocated_storage" {
  description = "RDS Max allocated storage"
  type        = number
  default     = 1000
}

variable "database_name" {
  description = "Database Name"
  type        = string
  ##default    = 1000
}

variable "master_username" {
  description = "Database Name"
  type        = string
  ##default   = admin
}

variable "port" {
  description = "The port on which to accept connections"
  type        = string
  default     = ""
}

variable "master_password" {
  description = "Master DB password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ for RDS instance"
  type        = bool
  default     = true
}

variable "preferred_maintenance_window" {
  description = "When to perform maintanance on the RDS"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "02:00-03:00"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Enable Cloudwatch logs exports"
  type        = list(string)
  default     = [
    "postgresql",
     "upgrade",
    ]
}

variable "create_cloudwatch_log_group" {
  description = "Create Cloudwatch log group"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  type        = bool
  description = "skip creating a final snapshot before deleting the DB"
  #set the value to false for production workload
  default = true
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

variable "snapshot_identifier" {
  description = "id of snapshot to restore. If you do not want to restore a db, leave the default empty string."
  type        = string
  default     = ""
}

variable "snapshot_db_cluster_identifer" {
  description = "id of snapshot to restore. If you do not want to restore a db, leave the default empty string."
  type        = string
  #default     = ""
}

variable "deletion_protection" {
  description = "Enable delete protection for the RDS"
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Enable PI for RDS"
  type        = bool
  default     = true
}

variable "performance_insights_retention_period" {
  description = "Enable retention period for PI"
  type        = number
  default     = 7
}

variable "create_monitoring_role" {
  description = "Monitoring role for Enhanced Monitoring"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "Monitoring interval for Enhanced Monitoring"
  type        = number
  default     = 60
}

variable "monitoring_role_name" {
  description = "Monitoring role for Enhanced Monitoring"
  type        = string
  default     = "example-monitoring-role-name"
}


variable "monitoring_role_use_name_prefix" {
  description = "Monitoring role prefix for Enhanced Monitoring"
  type        = bool
  default     = true
}

variable "monitoring_role_description" {
  description = "Monitoring role for Enhanced Monitoring"
  type        = string
  default     = "Description for monitoring role"
}
