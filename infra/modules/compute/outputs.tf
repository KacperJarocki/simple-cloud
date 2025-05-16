output "identity_principal_id" {
  value = azurerm_linux_web_app.web_app.identity[0].principal_id
}
