// Get the default AWS region
data "aws_region" "current" {}

// Get the latest ECS optimized AMI
data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

data "template_file" "this" {
  template = <<-EOT
    #!/bin/bash
    cat <<'EOF' >> /etc/ecs/ecs.config
    ECS_CLUSTER=${var.name}
    ECS_LOGLEVEL=debug
    EOF
  EOT
}
