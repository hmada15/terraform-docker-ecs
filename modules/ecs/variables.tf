variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "key_name" {
  description = "Name of the Key Pair"
  type        = string
}
variable "public_subnets" {
  type = list
}
