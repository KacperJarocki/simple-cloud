resource "azurerm_private_dns_zone" "database_zone" {
  name                = "${var.env}.${var.project}.postgres.database.azure.com"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  name                  = "${var.env}-${var.project}-database-server-zone.com"
  private_dns_zone_name = azurerm_private_dns_zone.database_zone.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.rg_name
}

resource "azurerm_postgresql_flexible_server" "db_server" {
  name                          = "${var.env}-${var.project}-database-server"
  location                      = var.location
  resource_group_name           = var.rg_name
  sku_name                      = "B_Standard_B1ms"
  version                       = "11"
  storage_mb                    = 32768
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  private_dns_zone_id           = azurerm_private_dns_zone.database_zone.id
  administrator_login           = "psqladmin"
  administrator_password        = var.postgres_password
  delegated_subnet_id           = var.subnet_id
  public_network_access_enabled = false

  high_availability {
    mode = "SameZone"
  }
  tags = {
    environment = var.env
  }
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "${var.env}-${var.project}-database"
  server_id = azurerm_postgresql_flexible_server.db_server.id
  charset   = "UTF8"

  lifecycle {
    prevent_destroy = true
  }
}
