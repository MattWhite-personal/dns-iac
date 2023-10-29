terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.78.0"
    }
  }
  backend "local" {
    path = "./terraform.tfstate"
  }
}
provider "azurerm" {

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {

  }
}

resource "azurerm_resource_group" "dnszones" {
  name     = "rg-whitefam-dnszones"
  location = "UK South"
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_resource_group" "cdnprofiles" {
  name     = "rg-whitefam-cdnprofiles"
  location = "UK South"
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_cdn_profile" "cdm-mta-sts" {
  name                = "cdn-mta-sts"
  location            = "global"
  resource_group_name = azurerm_resource_group.cdnprofiles.name
  sku                 = "Standard_Microsoft"
}
