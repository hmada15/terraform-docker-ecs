variable "name" {
  type    = string
  default = "example-ecs-components"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "Name of the Key Pair"
  type        = string
  default     = ""
}
