locals {
  name        = var.name_prefix ? null : var.name
  name_prefix = var.name_prefix ? "${var.name}-" : null

  description = "A sample option group"
}

resource "aws_db_subnet_group" "this" {
  count = var.create ? 1 : 0

  name        = local.name
  name_prefix = local.name_prefix
  description = local.description
  subnet_ids  = var.subnet_ids

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )
}
