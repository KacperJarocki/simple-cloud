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


resource "azurerm_user_assigned_identity" "uai" {
  name                = "${var.env}-${var.project}-uai"
  resource_group_name = var.rg_name
  location            = var.location
  tags = {
    environment = var.env
  }
}

resource "azurerm_key_vault_access_policy" "uai_policy" {
  key_vault_id = var.keyvault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.uai.principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
}

resource "null_resource" "wait_for_propagation" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    azurerm_key_vault_access_policy.uai_policy
  ]
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "${var.env}-${var.project}-web-app"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.uai.id,
    ]
  }

  key_vault_reference_identity_id = azurerm_user_assigned_identity.uai.id

  app_settings = {
    "DB_USER" = "@Microsoft.KeyVault(SecretUri=${var.db_user_secret_id})"
    "DB_PASS" = "@Microsoft.KeyVault(SecretUri=${var.db_pass_secret_id})"
    "DB_HOST" = "@Microsoft.KeyVault(SecretUri=${var.db_host_secret_id})"
    "DB_PORT" = "5432"
    "DB_NAME" = "${var.env}-${var.project}-database"
  }

  site_config {
    application_stack {
      docker_image_name   = "${var.docker_image_name}:${var.docker_image_tag}"
      docker_registry_url = "https://${var.docker_registry_url}"
    }
  }

  virtual_network_subnet_id = var.subnet_id
  tags = {
    environment = var.env
  }


  depends_on = [
    null_resource.wait_for_propagation
  ]
}
