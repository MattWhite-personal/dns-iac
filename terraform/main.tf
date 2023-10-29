terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.78.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "stwhitefamterraform"
    container_name = "tfstate"
    key            = "terraform.tfstate"
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

locals {
  tags = {
    source  = "terraform"
    managed = "as-code"
  }
}

resource "azurerm_resource_group" "dnszones" {
  name     = "rg-whitefam-dnszones"
  location = "UK South"
  tags     = local.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_resource_group" "cdnprofiles" {
  name     = "rg-whitefam-cdnprofiles"
  location = "UK South"
  tags     = local.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_cdn_profile" "cdm-mta-sts" {
  name                = "cdn-mjwmtasts"
  location            = "global"
  resource_group_name = azurerm_resource_group.cdnprofiles.name
  sku                 = "Standard_Microsoft"
  tags                = local.tags
}
