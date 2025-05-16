module "networks" {
  source        = "./modules/networking"
  address_space = ["10.0.0.0/16"]
  subnet_addresses = {
    compute  = "10.0.1.0/24"
    database = "10.0.2.0/24"
  }
  project = var.project
  env     = var.env
}
module "compute" {
  source   = "./modules/compute"
  location = module.networks.location
  rg_name  = module.networks.rg_name
}
