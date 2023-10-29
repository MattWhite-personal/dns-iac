resource "azurerm_dns_zone" "simonwhitedesign-co-uk" {
  name                = "simonwhitedesign.co.uk"
  resource_group_name = azurerm_resource_group.dnszones.name
  lifecycle {
    prevent_destroy = true
  }
}

module "swd-records" {
  source    = "./module/dnsrecords"
  zone_name = azurerm_dns_zone.simonwhitedesign-co-uk.name
  rg_name   = azurerm_resource_group.dnszones.name
  a-records = [
    {
      name = "@",
      records = [
        "198.185.159.144",
        "198.185.159.145",
        "198.49.23.144",
        "198.49.23.145"
      ],
      isAlias = false
    }
  ]
  aaaa-records = []
  caa-records  = []
  cname-records = [
    {
      name   = "autodiscover",
      record = "autodiscover.outlook.com.",
      isAlias = false
    },
    {
      name   = "ftp",
      record = "simonwhitedesign.co.uk.",
      isAlias = false
    },
    {
      name   = "mail",
      record = "simonwhitedesign.co.uk.",
      isAlias = false
    },
    {
      name   = "msoid",
      record = "clientconfig.microsoftonline-p.net.",
      isAlias = false
    },
    {
      name   = "selector1._domainkey",
      record = "selector1-simonwhitedesign-co-uk._domainkey.thewhitefamily.onmicrosoft.com.",
      isAlias = false
    },
    {
      name   = "selector2._domainkey",
      record = "selector2-simonwhitedesign-co-uk._domainkey.thewhitefamily.onmicrosoft.com.",
      isAlias = false
    },
    {
      name   = "www",
      record = "simonwhitedesign.co.uk.",
      isAlias = false
    }
  ]
  mx-records = [
    {
      name = "@"
      ttl  = 3600
      records = [
        {
          preference = 0
          exchange   = "simonwhitedesign-co-uk.mail.protection.outlook.com"
        }
      ]
    }
  ]
  ptr-records = []
  srv-records = []
  txt-records = [
    {
      name = "@",
      records = [
        "v=spf1 include:spf.protection.outlook.com -all",
        "MS=ms91095445"
      ]
    },
    {
      name    = "_dmarc",
      records = ["v=DMARC1; p=quarantine; pct=50; rua=mailto:dmarc@simonwhitedesign.co.uk; ruf=mailto:dmarc@simonwhitedesign.co.uk; fo=1"]
    },
    {
      name    = "_mta-sts",
      records = ["v=STSv1; id=202112091053"]
    },
    {
      name    = "_smtp._tls",
      records = ["v=TLSRPTv1; rua=mailto:tls-reports@matthewjwhite.co.uk"]
    }
  ]
}

module "swd-mtasts" {
  source                   = "./module/mtasts"
  use-existing-cdn-profile = true
  existing-cdn-profile     = azurerm_cdn_profile.cdm-mta-sts.name
  cdn-resource-group       = azurerm_resource_group.cdnprofiles.name
  dns-resource-group       = azurerm_resource_group.dnszones.name
  mx-records               = ["simonwhitedesign-co-uk.mail.protection.outlook.com"]
  domain-name              = azurerm_dns_zone.simonwhitedesign-co-uk.name
  depends_on               = [azurerm_resource_group.cdnprofiles, azurerm_resource_group.dnszones]
}