locals {
  is_prod = var.env == "prod"
}

resource "azurerm_frontdoor" "frontdoor" {
  count               = local.is_prod ? 1 : 0
  name                = "${var.env}-${var.project}-frontdoor"
  resource_group_name = var.rg_name

  # Wymagany blok health probe
  backend_pool_health_probe {
    name                = "defaultHealthProbe"
    protocol            = "Https"
    path                = "/"
    interval_in_seconds = 30
  }

  # Wymagany blok load balancing
  backend_pool_load_balancing {
    name                            = "defaultLoadBalancing"
    sample_size                     = 4
    successful_samples_required     = 2
    additional_latency_milliseconds = 0
  }

  # Frontend
  frontend_endpoint {
    name      = "defaultFrontendEndpoint"
    host_name = "${var.env}-${var.project}.azurefd.net"
  }

  # Backend Pool
  backend_pool {
    name                = "defaultBackendPool"
    load_balancing_name = "defaultLoadBalancing"
    health_probe_name   = "defaultHealthProbe"

    backend {
      host_header = var.backend_fqdn
      address     = var.backend_fqdn
      http_port   = 80
      https_port  = 443
      priority    = 1
      weight      = 50
    }
  }

  # Routing
  routing_rule {
    name               = "defaultRoutingRule"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["defaultFrontendEndpoint"]

    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "defaultBackendPool"
    }
  }

  tags = {
    environment = var.env
  }
}
