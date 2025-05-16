variable "env" {
  type    = string
  default = "dev"
}
variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}
variable "subnet_addresses" {
  type = map(string)
  default = {
    compute = "10.0.1.0/24"
    subnet2 = "10.0.2.0/24"
  }
}
variable "project" {
  type    = string
  default = "project"
}
