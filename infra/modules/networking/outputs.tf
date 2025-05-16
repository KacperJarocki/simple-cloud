output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}
output "subnet_ids" {
  value = {
    for key, subnet in azurerm_subnet.subnet :
    key => subnet.id
  }
}
