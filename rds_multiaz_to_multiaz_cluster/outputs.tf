
output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db_cluster.db_instance_arn
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db_cluster.db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db_cluster.db_instance_endpoint
}

output "db_instance_engine" {
  description = "The database engine"
  value       = module.db_cluster.db_instance_engine
}

output "db_instance_engine_version_actual" {
  description = "The running version of the database"
  value       = module.db_cluster.db_instance_engine_version_actual
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db_cluster.db_instance_hosted_zone_id
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db_cluster.db_instance_id
}

output "db_instance_name" {
  description = "The database name"
  value       = module.db_cluster.db_instance_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.db_cluster.db_instance_username
  sensitive   = true
}

output "db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.db_cluster.db_instance_password
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = module.db_cluster.db_instance_port
}

output "db_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.db_cluster.db_instance_cloudwatch_log_groups
}

output "snapshot_identifier" {
  description = "Snapshot used for restoring the Multi-AZ DB Cluster"
  value       = data.aws_db_cluster_snapshot.db_cluster_snapshot.id
}
