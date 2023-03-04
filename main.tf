module "network" {
  source = "./network"
  name   = var.name
}

module "ecs" {
  source         = "./ecs"
  name           = var.name
  key_name       = var.key_name
  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
}
