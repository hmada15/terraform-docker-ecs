
resource "aws_ecs_cluster" "this" {
  name = var.name
}

resource "aws_ecs_capacity_provider" "this" {
  name = var.name

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.idc.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.this.name
  }
}

resource "aws_ecs_task_definition" "this" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "laravel-nginx"
      image     = "corbosman/laravel-nginx-php"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
