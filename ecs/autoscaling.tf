resource "aws_autoscaling_group" "idc" {
  desired_capacity          = 1
  force_delete              = false
  force_delete_warm_pool    = false
  health_check_grace_period = 300
  health_check_type         = "EC2"
  max_size                  = 1
  metrics_granularity       = "1Minute"
  min_size                  = 0
  name_prefix               = "example-ecs-components-"
  protect_from_scale_in     = false
  termination_policies      = []
  wait_for_capacity_timeout = "10m"

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

}

resource "aws_iam_instance_profile" "this" {
  name_prefix = "example-ecs-components-"
  path        = "/"
  role        = aws_iam_role.this.id

  tags = {
    "key"                 = "AmazonECSManaged"
    "propagate_at_launch" = "true"
    "value"               = "true"
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Sid = "EC2AssumeRole"
        },
      ]
      Version = "2012-10-17"
    }
  )
  description           = "ECS role for example-ecs-components"
  force_detach_policies = true
  max_session_duration  = 3600
  name_prefix           = "example-ecs-components-"
  path                  = "/"

  tags = {
    "key"                 = "AmazonECSManaged"
    "propagate_at_launch" = "true"
    "value"               = "true"
  }
}

resource "aws_iam_role_policy_attachment" "EC2ContainerServiceforEC2Role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.this.id
}

resource "aws_iam_role_policy_attachment" "SSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.this.id
}

resource "aws_launch_template" "this" {
  image_id               = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type          = "t3.micro"
  key_name               = try(var.key_name, null)
  name_prefix            = "example-ecs-components-"
  user_data              = base64encode(data.template_file.this.rendered)
  vpc_security_group_ids = [aws_security_group.this.id]

  monitoring {
    enabled = true
  }
  tags = {
    "key"                 = "AmazonECSManaged"
    "propagate_at_launch" = "true"
    "value"               = "true"
  }
}
