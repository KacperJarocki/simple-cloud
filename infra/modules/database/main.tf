resource "azurerm_postgresql_server" "db_server" {
  name                = "${var.env}-${var.project}-database-server"
  location            = var.location
  resource_group_name = var.rg_name
  sku_name            = "B_Gen5_1"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "psqladmin"
  administrator_login_password = var.postgres_password
  version                      = "11"
  ssl_enforcement_enabled      = true

  tags = {
    environment = var.env
  }
}

resource "azurerm_postgresql_database" "db" {
  name                = "${var.env}-${var.project}-database"
  resource_group_name = var.rg_name
  server_name         = azurerm_postgresql_server.db_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  lifecycle {
    prevent_destroy = true
  }
}
