resource "azurerm_postgresql_flexible_server" "db_server" {
  name                = "${var.env}-${var.project}-database-server"
  location            = var.location
  resource_group_name = var.rg_name

  sku_name                     = "B_Standard_B1ms"
  version                      = "11"
  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = "psqladmin"
  administrator_login_password = var.postgres_password

  delegated_subnet_id = var.database_subnet_id

  high_availability {
    mode = "Disabled"
  }

  public_network_access_enabled = false

  tags = {
    environment = var.env
  }
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name                = "${var.env}-${var.project}-database"
  resource_group_name = var.rg_name
  server_name         = azurerm_postgresql_flexible_server.db_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  lifecycle {
    prevent_destroy = true
  }
}
