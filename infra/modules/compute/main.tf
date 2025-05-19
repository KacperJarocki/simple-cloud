data "azurerm_client_config" "current" {}

resource "azurerm_service_plan" "plan" {
  name                = "${var.env}-${var.project}-service-plan"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku
  tags = {
    environment = var.env
  }
}


resource "azurerm_linux_web_app" "web_app" {
  name                = "${var.env}-${var.project}-web-app"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id
  identity {
    type = "SystemAssigned"
  }
  app_settings = {
    "DB_USER" = "@Microsoft.KeyVault(SecretUri=${var.db_user_secret_id})"
    "DB_PASS" = "@Microsoft.KeyVault(SecretUri=${var.db_pass_secret_id})"
    "DB_HOST" = "@Microsoft.KeyVault(SecretUri=${var.db_host_secret_id})"
    "DB_PORT" = "5432"
    "DB_NAME" = "${var.env}-${var.project}-database"
  }
  depends_on = [
    azurerm_key_vault_access_policy.appservice_policy
  ]
  site_config {

    application_stack {
      docker_image_name   = "${var.docker_image_name}:${var.docker_image_tag}"
      docker_registry_url = "https://${var.docker_registry_url}"
    }
  }
  tags = {
    environment = var.env
  }
}
resource "azurerm_app_service_virtual_network_swift_connection" "connection" {
  app_service_id = azurerm_linux_web_app.web_app.id
  subnet_id      = var.subnet_id
}

resource "azurerm_key_vault_access_policy" "appservice_policy" {
  key_vault_id = var.keyvault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.web_app.identity[0].principal_id

  depends_on = [
    azurerm_linux_web_app.web_app
  ]
  secret_permissions = [
    "Get",
    "List"
  ]
}
