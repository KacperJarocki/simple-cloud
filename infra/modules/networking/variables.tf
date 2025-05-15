variable "env" {
  type    = string
  default = "dev"
}

variable "subnet_addresses" {
  type = map(string)
  default = {
    subnet1 = "10.0.1.0/24"
    subnet2 = "10.0.2.0/24"
  }
}
