terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.7.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {}
