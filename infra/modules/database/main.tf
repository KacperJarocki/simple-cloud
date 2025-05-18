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
  zone                          = "1"

  tags = {
    environment = var.env
  }
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "${var.env}-${var.project}-database"
  server_id = azurerm_postgresql_flexible_server.db_server.id
  charset   = "UTF8"
}
resource "null_resource" "trigger_github" {
  provisioner "local-exec" {
    command = <<EOT
    curl -X POST https://api.github.com/repos/${lower(var.github_user)}/${lower(var.project)}/dispatches \
      -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: token ${var.github_token}" \
      -H "Content-Type: application/json" \
      -d '{
        "event_type": "database-created",
        "client_payload": {
          "db_name": "${azurerm_postgresql_flexible_server_database.db.name}",
          "db_host": "${azurerm_postgresql_flexible_server.db_server.fqdn}",
          "db_user": "psqladmin",
          "db_password": "${var.postgres_password}"
        }
      }'
    EOT
  }

  depends_on = [azurerm_postgresql_flexible_server_database.db]
}
