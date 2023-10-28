resource "azurerm_dns_zone" "matthewjwhite-co-uk" {
  name                = "testmatthewjwhite.co.uk"
  resource_group_name = azurerm_resource_group.dnszones.name
}

