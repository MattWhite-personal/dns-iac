# Obtain Azure Front Door service tags for backend communication
data "azurerm_network_service_tags" "AzureFrontDoor-BackEnd" {
  location = "uksouth"
  service  = "AzureFrontDoor.Backend"
}