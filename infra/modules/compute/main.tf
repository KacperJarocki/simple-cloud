resource "azurerm_service_plan" "plan" {
  name                = "${var.env}-${var.project}-service-plan"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku
  tags = {
    enviroment = var.env
  }
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "example"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}
  tags = {
    enviroment = var.env
  }
  application_stack {
    docker_image_name   = "${var.docker_image_name}:${var.docker_image_tag}"
    docker_registry_url = var.docker_registry_url
  }
}
resource "azurerm_app_service_virtual_network_swift_connection" "example" {
  app_service_id = azurerm_linux_web_app.web_app.id
  subnet_id      = var.subnet_id
}
