resource "azurerm_dns_zone" "tonyandlizwhite-co-uk" {
  name                = "tonyandlizwhite.co.uk"
  resource_group_name = azurerm_resource_group.dnszones.name
  lifecycle {
    prevent_destroy = true
  }
}

module "tlw-records" {
  source       = "./module/dnsrecords"
  zone_name    = azurerm_dns_zone.tonyandlizwhite-co-uk.name
  rg_name      = azurerm_resource_group.dnszones.name
  a-records    = []
  aaaa-records = []
  caa-records  = []
  cname-records = [
    {
      name    = "autodiscover",
      record  = "autodiscover.outlook.com.",
      isAlias = false
    },
    {
      name    = "cdnverify.mta-sts",
      record  = "cdnverify.cdntlwmtasts.azureedge.net",
      isAlias = false
    },
    {
      name    = "enterpriseenrollment",
      record  = "enterpriseenrollment.manage.microsoft.com.",
      isAlias = false
    },
    {
      name    = "enterpriseregistration",
      record  = "enterpriseregistration.windows.net.",
      isAlias = false
    },
    {
      name    = "lyncdiscover",
      record  = "webdir.online.lync.com.",
      isAlias = false
    },
    {
      name    = "mta-sts",
      record  = "",
      isAlias = false
    },
    {
      name    = "selector1._domainkey",
      record  = "selector1-tonyandlizwhite-co-uk._domainkey.thewhitefamily.onmicrosoft.com.",
      isAlias = false
    },
    {
      name    = "selector2._domainkey",
      record  = "selector2-tonyandlizwhite-co-uk._domainkey.thewhitefamily.onmicrosoft.com.",
      isAlias = false
    },
    {
      name    = "sip",
      record  = "sipdir.online.lync.com.",
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
          exchange   = "tonyandlizwhite-co-uk.mail.protection.outlook.com"
        }
      ]
    }
  ]
  ptr-records = []
  srv-records = []
  txt-records = [
    {
      name    = "@",
      records = ["v=spf1 include:spf.protection.outlook.com -all"]
    },
    {
      name    = "_dmarc",
      records = ["v=DMARC1; p=quarantine; pct=50; rua=mailto:dmarc@tonyandlizwhite.co.uk; ruf=mailto:dmarc@tonyandlizwhite.co.uk; fo=1"]
    }
  ]
}

module "tlw-mtasts" {
  source                   = "./module/mtasts"
  use-existing-cdn-profile = true
  existing-cdn-profile     = azurerm_cdn_profile.cdm-mta-sts.name
  cdn-resource-group       = azurerm_resource_group.cdnprofiles.name
  dns-resource-group       = azurerm_resource_group.dnszones.name
  mx-records               = ["tonyandlizwhite-co-uk.mail.protection.outlook.com"]
  domain-name              = azurerm_dns_zone.tonyandlizwhite-co-uk.name
  depends_on               = [azurerm_resource_group.cdnprofiles, azurerm_resource_group.dnszones]
}
