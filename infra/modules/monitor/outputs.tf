output "app_insights_instrumentation_key_secret" {
  value = azurerm_key_vault_secret.app_insights_instrumentation_key_secret.id
}

output "app_insights_connection_string_secret" {
  value = azurerm_key_vault_secret.app_insights_connection_string_secret.id
}
