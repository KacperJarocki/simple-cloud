variable "env" {
  type        = string
  default     = "dev"
  description = "The environment for the deployment (e.g., dev, staging, prod)."
}

variable "project" {
  type        = string
  default     = "project"
  description = "The name of the project this infrastructure belongs to."
}

variable "rg_name" {
  type        = string
  description = "The name of the Azure Resource Group where resources will be deployed."
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be deployed (e.g., westeurope, eastus)."
}

variable "sku" {
  type        = string
  default     = "F1"
  description = "The pricing tier or SKU for the resource (e.g., for App Service Plans)."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet in which resources like containers or services will be deployed."
}
variable "postgres_password" {
  type        = string
  sensitive   = true
  description = "Password"
}

variable "vnet_id" {
  type        = string
  description = "The ID of the vnet in which resources like containers or services will be deployed."
}
