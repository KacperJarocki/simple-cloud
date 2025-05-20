data "azurerm_client_config" "current" {}

locals {
  is_prod       = lower(var.env) == "prod"
  plan_sku      = local.is_prod ? "P1v2" : var.sku
  plan_capacity = local.is_prod ? 3 : 1
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.env}-${var.project}-service-plan"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = local.plan_sku
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

resource "azurerm_linux_web_app" "web_app" {
  name                = "${var.env}-${var.project}-web-app"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  lifecycle {
    create_before_destroy = true
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.uai.id,
    ]
  }

  key_vault_reference_identity_id = azurerm_user_assigned_identity.uai.id

  app_settings = {
    "DB_USER"                                    = "@Microsoft.KeyVault(SecretUri=${var.db_user_secret_id})"
    "DB_PASS"                                    = "@Microsoft.KeyVault(SecretUri=${var.db_pass_secret_id})"
    "DB_HOST"                                    = "@Microsoft.KeyVault(SecretUri=${var.db_host_secret_id})"
    "DB_PORT"                                    = "5432"
    "DB_NAME"                                    = "${var.env}-${var.project}-database"
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = "@Microsoft.KeyVault(SecretUri=${var.appinsights_connection_string_secret_uri})"
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = "@Microsoft.KeyVault(SecretUri=${var.appinsights_instrumentation_key_secret_uri})"
    "APPLICATIONINSIGHTS_ROLE_NAME"              = var.app_role_name
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
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
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  count = lower(var.env) == "prod" ? 1 : 0

  name                = "${var.env}-${var.project}-autoscale"
  resource_group_name = var.rg_name
  target_resource_id  = azurerm_service_plan.plan.id
  enabled             = true
  location            = var.location
  profile {
    name = "AutoScaleProfile"
    capacity {
      minimum = "1"
      maximum = "5"
      default = "3"
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
