output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.my_subnet[*].id
}

output "db_security_group_id" {
  description = "The db subnet group name"
  value       = aws_security_group.my_security_group.id
}
