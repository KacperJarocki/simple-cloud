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
  default     = "B1"
  description = "The pricing tier or SKU for the resource (e.g., for App Service Plans)."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet in which resources like containers or services will be deployed."
}

variable "docker_image_name" {
  type        = string
  description = "The name of the Docker image to be deployed (excluding the tag)."
}

variable "docker_image_tag" {
  type        = string
  description = "The tag of the Docker image to deploy (e.g., latest, v1.0.0)."
}

variable "docker_registry_url" {
  type        = string
  description = "The URL of the Docker registry from which the image will be pulled."
}

variable "db_user_secret_id" {
  type = string
}

variable "db_pass_secret_id" {
  type = string
}

variable "db_host_secret_id" {
  type = string
}
