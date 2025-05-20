variable "env" {
  type        = string
  description = "The environment for the deployment (e.g., dev, staging, prod)."
}
variable "project" {
  type        = string
  description = "The name of the project associated with this deployment."
}
variable "location" {
  type        = string
  description = "The geographical location where resources will be deployed."
}
variable "rg_name" {
  type        = string
  description = "The name of the resource group to use or create."
}
variable "kv_id" {
  type        = string
  description = "The ID of the Key Vault to use for storing secrets."
}
