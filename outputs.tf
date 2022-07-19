output "vpc_id" {
  description = "Id of the VPC"
  value       = module.vpc.vpc_id
}

output "autoscaling_group_arn" {
  description = "ARN of the Autoscaling group"
  value       = aws_ecs_capacity_provider.this.arn
}

output "cluster_name" {
  description = "Name of the cluster"
  value       = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  description = "ARN of the cluster"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_id" {
  description = "ID of the cluster"
  value       = aws_ecs_cluster.this.id
}

