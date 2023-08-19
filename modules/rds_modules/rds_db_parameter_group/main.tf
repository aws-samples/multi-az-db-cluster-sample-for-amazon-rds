locals {
  name        = var.name_prefix ? null : var.name
  name_prefix = var.name_prefix ? "${var.name}-" : null

  description = "A sample Parameter group"
}

resource "aws_rds_cluster_parameter_group" "this" {
  count = var.create ? 1 : 0

  name        = local.name
  name_prefix = local.name_prefix
  description = local.description
  family      = var.family

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "this" {
  count = var.create ? 1 : 0

  name        = local.name
  name_prefix = local.name_prefix
  description = local.description
  family      = var.family

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}
