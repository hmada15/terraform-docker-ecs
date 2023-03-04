module "network" {
  source = "./modules/network"
  name   = var.name
}

module "ecs" {
  source         = "./modules/ecs"
  name           = var.name
  key_name       = var.key_name
  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
}
