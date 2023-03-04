resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    "Name" = var.name
  }
}

resource "aws_internet_gateway" "this" {
  tags = {
    "Name" = var.name
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.name}-public"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}


# resource "aws_subnet" "subnet-public-b" {
#   vpc_id                                         = aws_vpc.this.id
#   assign_ipv6_address_on_creation                = false
#   availability_zone                              = "${data.aws_region.current.name}b"
#   cidr_block                                     = "10.0.102.0/24"
#   enable_dns64                                   = false
#   enable_resource_name_dns_a_record_on_launch    = false
#   enable_resource_name_dns_aaaa_record_on_launch = false
#   ipv6_native                                    = false
#   map_public_ip_on_launch                        = true
#   tags = {
#     "Name" = "${var.name}-public-eu-west-1b"
#   }
# }

# resource "aws_subnet" "subnet-public-c" {
#   vpc_id                                         = aws_vpc.this.id
#   assign_ipv6_address_on_creation                = false
#   availability_zone                              = "${data.aws_region.current.name}c"
#   cidr_block                                     = "10.0.103.0/24"
#   enable_dns64                                   = false
#   enable_resource_name_dns_a_record_on_launch    = false
#   enable_resource_name_dns_aaaa_record_on_launch = false
#   ipv6_native                                    = false
#   map_public_ip_on_launch                        = true
#   tags = {
#     "Name" = "${var.name}-public-eu-west-1c"
#   }
# }

resource "aws_subnet" "public" {
  for_each = var.subnet_cidr_block

  vpc_id                                         = aws_vpc.this.id
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "${data.aws_region.current.name}${each.key}"
  cidr_block                                     = each.value
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = true
}

resource "aws_route_table_association" "this" {
  for_each = aws_subnet.public

  route_table_id = aws_route_table.this.id
  subnet_id      = each.value.id

}

# resource "aws_route_table_association" "public-b" {
#   route_table_id = aws_route_table.this.id
#   subnet_id      = aws_subnet.subnet-public-b.id
# }

# resource "aws_route_table_association" "public-c" {
#   route_table_id = aws_route_table.this.id
#   subnet_id      = aws_subnet.subnet-public-c.id
# }
