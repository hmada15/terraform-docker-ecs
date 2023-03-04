resource "aws_security_group" "this" {
  vpc_id                 = var.vpc_id
  name_prefix            = "example-ecs-components-"
  description            = "Autoscaling group security group"
  revoke_rules_on_delete = false
  tags = {
    "Name" = "example-ecs-components"
  }

  timeouts {
    create = "10m"
    delete = "15m"
  }
}

resource "aws_security_group_rule" "egress_rules" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = "All protocols"
  from_port   = -1
  ipv6_cidr_blocks = [
    "::/0",
  ]
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  to_port           = -1
  type              = "egress"
}

resource "aws_security_group_rule" "ingress_https_rules" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description       = "HTTPS"
  from_port         = 443
  ipv6_cidr_blocks  = []
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "ingress_http_rules" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description       = "HTTP"
  from_port         = 80
  ipv6_cidr_blocks  = []
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 80
  type              = "ingress"
}
