terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.30.0"
    }
  }
  backend "local" {
    path = "./terraform.tfstate"
  }
}
provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "dnszones" {
  name     = "rg-whitefam-dnszones"
  location = "UK South"
}

resource "azurerm_resource_group" "cdnprofiles" {
  name     = "rg-whitefam-cdnprofiles"
  location = "UK South"
}
