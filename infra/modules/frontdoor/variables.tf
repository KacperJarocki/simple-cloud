variable "env" {
  type        = string
  description = "Środowisko (np. dev, staging, prod)"
}

variable "rg_name" {
  type        = string
  description = "Nazwa resource group"
}

variable "location" {
  type        = string
  description = "Region Azure"
}

variable "project" {
  type        = string
  description = "Nazwa projektu"
}


variable "backend_host" {
  description = "Nazwa hosta backendu (np. App Service)"
  type        = string
}

variable "backend_fqdn" {
  description = "FQDN backendu (np. app.azurewebsites.net)"
  type        = string
}
