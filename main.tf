module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.name

  cidr = "10.0.0.0/16"

  azs            = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_dns_hostnames = true

  tags = var.tags
}

// Get the latest ECS optimized AMI
data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.5"

  name          = var.name
  instance_type = "t3.micro"

  image_id = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]

  security_groups                 = [module.autoscaling_sg.security_group_id]
  ignore_desired_capacity_changes = true

  create_iam_instance_profile = true

  iam_role_name        = var.name
  iam_role_description = "ECS role for ${var.name}"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  vpc_zone_identifier = module.vpc.public_subnets
  health_check_type   = "EC2"
  min_size            = 0
  max_size            = 2
  desired_capacity    = 1

  tags = var.tags
}

module "autoscaling_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.name
  description = "Autoscaling group security group"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]

  egress_rules = ["all-all"]

  tags = var.tags
}

resource "aws_ecs_cluster" "this" {
  name = var.name
}

resource "aws_ecs_capacity_provider" "this" {
  name = var.name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.autoscaling.autoscaling_group_arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}
