resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.env}-${var.project}-log-workspace"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "this" {
  name                = "${var.env}-${var.project}-app_insights"
  location            = var.location
  resource_group_name = var.rg_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.this.id
}

resource "azurerm_key_vault_secret" "app_insights_connection_string_secret" {
  name         = "${var.env}-aicss"
  value        = azurerm_application_insights.this.connection_string
  key_vault_id = var.kv_id
}

resource "azurerm_key_vault_secret" "app_insights_instrumentation_key_secret" {
  name         = "${var.env}-aiik"
  value        = azurerm_application_insights.this.instrumentation_key
  key_vault_id = var.kv_id
}

