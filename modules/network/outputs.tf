output "vpc_id" {
  description = "Id of the VPC"
  value       = aws_vpc.this.id
}
# output "public_subnets" {
#   description = "List of IDs of public subnets"
#   value       = aws_subnet.this[*].id
# }
output "public_subnets" {
  description = "List of IDs of public subnets"
  # value       = aws_subnet.public[*].id
  value       = []
}
