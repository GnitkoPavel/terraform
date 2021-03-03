# Deploy Networking Resources

module "network" {
  source       = "./network"
  vpc_cidr     = var.vpc_cidr
  public_cidrs = var.public_cidrs
  accessip     = var.accessip
}

# Deploy Compute Resources
module "compute" {
  source             = "./compute"
  security_group     = module.network.public_sg
  subnets            = module.network.public_subnets
  instance_type      = var.instance_type
  key_name           = var.key_name
  public_key_path    = file("/root/.ssh/id_rsa.pub")
  availability_zones = module.network.availability_zones
}