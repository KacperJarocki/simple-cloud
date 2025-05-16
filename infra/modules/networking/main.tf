resource "azurerm_resource_group" "rg" {
  name     = "${var.env}-${var.project}-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.env}-${var.project}-vnet"
  address_space       = var.address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_compute" {
  name                 = "${var.env}-${var.project}-compute-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_addresses["compute"]]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
resource "azurerm_subnet" "subnet_database" {
  name                 = "${var.env}-${var.project}-compute-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_addresses["database"]]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}
resource "azurerm_subnet" "subnets" {
  for_each             = { for k, v in var.subnet_addresses : k => v if !contains(["compute"], k) }
  name                 = "${var.env}-${var.project}-${each.key}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}
