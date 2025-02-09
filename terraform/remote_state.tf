data "terraform_remote_state" "web-server" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-whitefam-terraform"
    storage_account_name = "stwhitefamterraform"
    container_name       = "tfstate"
    key                  = "web-hosting.tfstate"
    use_oidc             = true
  }
}
