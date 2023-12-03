output "privatezone-keyvault" {
  value = azurerm_private_dns_zone.keyvault.id
}

output "rg-dnszones" {
    value = azurerm_resource_group.dnszones.name
}