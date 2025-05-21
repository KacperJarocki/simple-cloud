module "networks" {
  source        = "./modules/networking"
  address_space = ["10.0.0.0/16"]
  subnet_addresses = {
    compute  = "10.0.1.0/24"
    database = "10.0.5.0/24"
    keyvault = "10.0.3.0/24"
  }
  project = var.project
  env     = var.env
}
module "compute" {
  project                                    = var.project
  env                                        = var.env
  source                                     = "./modules/compute"
  location                                   = module.networks.location
  rg_name                                    = module.networks.rg_name
  docker_image_name                          = var.docker_image_name
  docker_image_tag                           = var.docker_image_tag
  docker_registry_url                        = var.docker_registry_url
  subnet_id                                  = module.networks.subnet_ids["compute"]
  db_user_secret_id                          = azurerm_key_vault_secret.db_user.id
  db_host_secret_id                          = azurerm_key_vault_secret.db_host.id
  db_pass_secret_id                          = azurerm_key_vault_secret.db_pass.id
  keyvault_id                                = module.keyvault.keyvault_id
  appinsights_connection_string_secret_uri   = module.monitor.app_insights_connection_string_secret
  appinsights_instrumentation_key_secret_uri = module.monitor.app_insights_instrumentation_key_secret
  app_role_name                              = "${var.env}-${var.project}"
  depends_on = [
    module.networks,
    module.keyvault
  ]
}

module "keyvault" {
  source             = "./modules/keyvault"
  env                = var.env
  project            = var.project
  location           = var.location
  rg_name            = module.networks.rg_name
  keyvault_subnet_id = module.networks.subnet_ids["keyvault"]
  vnet_id            = module.networks.vnet_id
}
module "monitor" {
  source   = "./modules/monitor"
  rg_name  = module.networks.rg_name
  env      = var.env
  project  = var.project
  location = var.location
  kv_id    = module.keyvault.keyvault_id
}

resource "random_password" "pg_password" {
  length  = 16
  special = true
}

module "database" {
  source            = "./modules/database"
  postgres_password = random_password.pg_password.result
  rg_name           = module.networks.rg_name
  location          = module.networks.location
  env               = var.env
  project           = var.project
  subnet_id         = module.networks.subnet_ids["database"]
  vnet_id           = module.networks.vnet_id
}

module "frontdoor" {
  source       = "./modules/frontdoor"
  rg_name      = module.networks.rg_name
  location     = module.networks.location
  env          = var.env
  project      = var.project
  backend_host = module.compute.web_app_name
  backend_fqdn = module.compute.web_app_default_hostname

  depends_on = [
    module.compute
  ]
}

resource "azurerm_key_vault_secret" "db_user" {
  name         = "db-username"
  value        = "psqladmin"
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "db_pass" {
  name         = "db-password"
  value        = random_password.pg_password.result
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "db_host" {
  name         = "db-host"
  value        = module.database.db_fqdn
  key_vault_id = module.keyvault.keyvault_id
}
