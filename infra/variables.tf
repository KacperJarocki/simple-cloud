variable "project" {
  type        = string
  description = "The name of the project this module is associated with."
}

variable "env" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)."
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be deployed (e.g., westeurope, eastus)."
}

variable "docker_image_name" {
  type        = string
  description = "The name of the Docker image to be deployed (without the tag)."
}

variable "docker_image_tag" {
  type        = string
  description = "The tag of the Docker image to be deployed (e.g., latest, v1.0.0)."
}

variable "docker_registry_url" {
  type        = string
  description = "The URL of the Docker registry from which the image will be pulled."
}
variable "github_token" {
  type        = string
  description = "Github Pat token wiht repo and workflows permissions"
}
variable "github_user" {
  type        = string
  description = "Github repo owner, user or organization"
}
