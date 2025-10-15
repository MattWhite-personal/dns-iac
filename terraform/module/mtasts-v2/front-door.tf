resource "azurerm_cdn_frontdoor_profile" "mta-sts" {
  count               = var.use-existing-front-door ? 0 : 1
  name                = "afd-mta-sts"
  resource_group_name = data.azurerm_resource_group.afd.name
  sku_name            = lookup(local.afd-version, var.afd-version, local.afd-version["default"])

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "mta-sts" {
  name                     = local.afd-prefix
  cdn_frontdoor_profile_id = local.front-door-id
}

resource "azurerm_cdn_frontdoor_origin_group" "mta-sts" {
  name                     = local.afd-prefix
  cdn_frontdoor_profile_id = local.front-door-id

  load_balancing {}
}

resource "azurerm_cdn_frontdoor_origin" "mta-sts" {
  name                           = "example-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.mta-sts.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_storage_account.mta-sts.primary_web_host
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_storage_account.mta-sts.primary_web_host
  priority                       = 1
  weight                         = 1
}

resource "azurerm_cdn_frontdoor_route" "mta-sts" {
  name                          = local.afd-prefix
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.mta-sts.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.mta-sts.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.mta-sts.id]

  supported_protocols             = ["Http", "Https"]
  patterns_to_match               = ["/*"]
  forwarding_protocol             = "HttpsOnly"
  link_to_default_domain          = false
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.mta-sts.id]
  https_redirect_enabled          = true
}

resource "azurerm_cdn_frontdoor_custom_domain" "mta-sts" {
  name                     = local.afd-prefix
  cdn_frontdoor_profile_id = local.front-door-id
  dns_zone_id              = data.azurerm_dns_zone.zone.id
  host_name                = "${azurerm_dns_cname_record.mta-sts.name}.${azurerm_dns_cname_record.mta-sts.zone_name}"

  tls {
    certificate_type = "ManagedCertificate"
  }

}

resource "azurerm_cdn_frontdoor_custom_domain_association" "mta-sts" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.mta-sts.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.mta-sts.id]
}