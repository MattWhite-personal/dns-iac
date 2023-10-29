resource "azurerm_dns_zone" "benchspace-uk" {
  name                = "benchspace.uk"
  resource_group_name = azurerm_resource_group.dnszones.name
  lifecycle {
    prevent_destroy = true
  }
}

module "bs-uk-records" {
  source    = "./module/dnsrecords"
  zone_name = azurerm_dns_zone.benchspace-uk.name
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
      record = "autodiscover.outlook.com",
      isAlias = false
    },
    {
      name   = "enterpriseenrollment",
      record = "enterpriseenrollment.manage.microsoft.com",
      isAlias = false
    },
    {
      name   = "enterpriseregistration",
      record = "enterpriseregistration.windows.net",
      isAlias = false
    },
    {
      name   = "nhty6l3pj4xw4kj6tybz",
      record = "verify.squarespace.com",
      isAlias = false
    },
    {
      name   = "selector1._domainkey",
      record = "selector1-benchspace-co._domainkey.objectatelier.onmicrosoft.com",
      isAlias = false
    },
    {
      name   = "selector2._domainkey",
      record = "selector2-benchspace-co._domainkey.objectatelier.onmicrosoft.com",
      isAlias = false
    },
    {
      name   = "www",
      record = "ext-cust.squarespace.com",
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
          exchange   = "benchspace-co.mail.protection.outlook.com"
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
        "MS=ms59722365",
        "v=spf1 include:spf.protection.outlook.com -all"
      ]
    }
  ]
}

/*
module "bs-co-mtasts" {
  source                   = "./module/mtasts"
  use-existing-cdn-profile = true
  existing-cdn-profile     = azurerm_cdn_profile.cdm-mta-sts.name
  cdn-resource-group       = azurerm_resource_group.cdnprofiles.name
  dns-resource-group       = azurerm_resource_group.dnszones.name
  mx-records               = ["benchspace-co.mail.protection.outlook.com"]
  domain-name              = azurerm_dns_zone.benchspace-co.name
  depends_on               = [azurerm_resource_group.cdnprofiles, azurerm_resource_group.dnszones]
}
*/
