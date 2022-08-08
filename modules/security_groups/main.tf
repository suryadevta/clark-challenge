resource "aws_security_group" "secgrp" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.tags

    dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
 dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = "tcp"
      cidr_blocks = egress.value.cidr_blocks
    }
  }
   revoke_rules_on_delete = var.revoke_rules_on_delete
}