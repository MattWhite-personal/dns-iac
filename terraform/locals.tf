locals {
  tags = {
    source     = "terraform"
    managed    = "as-code"
    repository = var.repository
  }
  permitted-ips = flatten([
    for cidr in concat(data.azurerm_network_service_tags.AzureFrontDoor-BackEnd.ipv4_cidrs, [var.runner-ip]) : (
      tonumber(split("/", cidr)[1]) >= 31 ?
      [
        for i in range(
          tonumber(split("/", cidr)[1]) == 32 ? 1 : 2
        ) : cidrhost(cidr, i)
      ] :
      [cidr]
    )
  ])
}