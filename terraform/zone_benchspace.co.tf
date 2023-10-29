resource "azurerm_dns_zone" "benchspace-co" {
  name                = "benchspace.co"
  resource_group_name = azurerm_resource_group.dnszones.name
  lifecycle {
    prevent_destroy = true
  }
}

module "bs-co-records" {
  source    = "./module/dnsrecords"
  zone_name = azurerm_dns_zone.benchspace-co.name
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
      name   = "rmdgz9dlw9pjf6pw7x3l",
      record = "verify.squarespace.com",
      isAlias = false
    },
    {
      name   = "selector1._domainkey",
      record = "selector1-benchspace-uk._domainkey.objectatelier.onmicrosoft.com",
      isAlias = false
    },
    {
      name   = "selector2._domainkey",
      record = "selector2-benchspace-uk._domainkey.objectatelier.onmicrosoft.com",
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
        "MS=ms19634485",
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