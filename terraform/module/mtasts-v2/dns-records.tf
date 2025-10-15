resource "azurerm_dns_cname_record" "mta-sts" {
  name                = "mta-sts"
  zone_name           = data.azurerm_dns_zone.zone.name
  resource_group_name = data.azurerm_resource_group.dns.name
  ttl                 = 300
  record              = azurerm_cdn_frontdoor_endpoint.mta-sts.host_name
  tags                = var.tags
}

resource "azurerm_dns_txt_record" "dnsauth" {
  name                = join(".", ["_dnsauth", "mta-sts"])
  zone_name           = data.azurerm_dns_zone.zone.name
  resource_group_name = data.azurerm_resource_group.dns.name
  ttl                 = 300
  tags                = var.tags

  record {
    value = azurerm_cdn_frontdoor_custom_domain.mta-sts.validation_token
  }
}

resource "azurerm_dns_txt_record" "mta-sts" {
  name                = "_mta-sts"
  zone_name           = data.azurerm_dns_zone.zone.name
  resource_group_name = data.azurerm_resource_group.dns.name
  ttl                 = 300
  tags                = var.tags

  record {
    value = "v=STSv1; id=${local.policyhash}"
  }
}

resource "azurerm_dns_txt_record" "smtp-tls" {
  name                = "_smtp._tls"
  zone_name           = data.azurerm_dns_zone.zone.name
  resource_group_name = data.azurerm_resource_group.dns.name
  ttl                 = 300
  tags                = var.tags

  record {
    value = "v=TLSRPTv1; rua=mailto:${local.tls_rpt_email}"
  }
}
