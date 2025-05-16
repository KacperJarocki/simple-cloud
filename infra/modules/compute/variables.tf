variable "env" {
  type    = string
  default = "dev"
}
variable "project" {
  type    = string
  default = "project"
}

variable "rg_name" {
  type = string
}
variable "location" {
  type = string
}
variable "sku" {
  type    = string
  default = "F1"
}
variable "subnet_id" {

}
variable "docker_image_name" {
  type = string
}

variable "docker_image_tag" {
  type = string
}
variable "docker_registry_url" {
  type = string
}
