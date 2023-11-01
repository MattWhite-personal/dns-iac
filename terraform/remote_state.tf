data "terraform_remote_state" "web-server" {
  backend = "azurerm"

  config = {
    storage_account_name = "stwhitefamterraform"
    container_name       = "tfstate"
    key                  = "web-hosting.tfstate"

  }
}
