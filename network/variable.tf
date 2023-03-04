variable "name" {
  type = string
}
variable "subnet_cidr_block" {
  type = map(any)
  default = {
    "a" = "10.0.101.0/24"
    "b" = "10.0.102.0/24"
    "c" = "10.0.103.0/24"
  }
}
