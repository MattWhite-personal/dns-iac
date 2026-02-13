terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.60.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-whitefam-terraform"
    storage_account_name = "stwhitefamterraform"
    container_name       = "tfstate"
    key                  = "dns-iac.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
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

resource "azurerm_cdn_profile" "cdn-mta-sts" {
  name                = "cdn-mjwmtasts"
  location            = "global"
  resource_group_name = azurerm_resource_group.cdnprofiles.name
  sku                 = "Standard_Microsoft"
  tags                = local.tags
}
