data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                     = "${var.env}-${var.project}-kv"
  location                 = var.location
  resource_group_name      = var.rg_name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "Set", "List", "Delete", "Recover", "Purge"
    ]
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_private_endpoint" "kv_pe" {
  name                = "${var.env}-${var.project}-kv-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.keyvault_subnet_id

  private_service_connection {
    name                           = "${var.env}-${var.project}-kv-conn"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "kv_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_dns_link" {
  name                  = "${var.env}-${var.project}-kv-dns-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.kv_dns.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "kv_a_record" {
  name                = azurerm_key_vault.kv.name
  zone_name           = azurerm_private_dns_zone.kv_dns.name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.kv_pe.private_service_connection[0].private_ip_address]
}
