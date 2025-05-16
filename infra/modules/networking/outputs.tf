output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "subnet_ids" {
  value = merge(
    {
      compute = azurerm_subnet.subnet_compute.id,
    },
    {
      for k, subnet in azurerm_subnet.subnets :
      k => subnet.id
    }
  )
}
