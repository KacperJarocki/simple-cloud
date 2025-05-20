
output "web_app_name" {
  value = azurerm_linux_web_app.web_app.name
}

output "web_app_default_hostname" {
  value = azurerm_linux_web_app.web_app.default_hostname
}
