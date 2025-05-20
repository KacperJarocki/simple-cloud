variable "env" {
  type        = string
  description = "Environment (e.g., dev, staging, prod)"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "project" {
  type        = string
  description = "Project name"
}


variable "backend_host" {
  description = "Backend host name (e.g., App Service)"
  type        = string
}

variable "backend_fqdn" {
  description = "Backend FQDN (e.g., app.azurewebsites.net)"
  type        = string
}
