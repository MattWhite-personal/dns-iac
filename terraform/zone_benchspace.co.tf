resource "azurerm_dns_zone" "benchspace-co" {
  name                = "benchspace.co"
  resource_group_name = azurerm_resource_group.dnszones.name
  lifecycle {
    prevent_destroy = true
  }
  tags = local.tags
}

module "bs-co-records" {
  source    = "./module/dnsrecords"
  zone_name = azurerm_dns_zone.benchspace-co.name
  rg_name   = azurerm_resource_group.dnszones.name
  tags      = local.tags
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
  caa-records = [
    {
      name = "@"
      ttl  = 3600
      records = [
        {
          flags = 0
          tag   = "issue"
          value = "digicert.com"
        },
        {
          flags = 0
          tag   = "issue"
          value = "letsencrypt.org"
        },
        {
          flags = 0
          tag   = "iodef"
          value = "mailto:dnscaa@matthewjwhite.co.uk"
        }
      ]
    }
  ]
  cname-records = [
    {
      name    = "autodiscover",
      record  = "autodiscover.outlook.com",
      isAlias = false
    },
    {
      name    = "enterpriseenrollment",
      record  = "enterpriseenrollment.manage.microsoft.com",
      isAlias = false
    },
    {
      name    = "enterpriseregistration",
      record  = "enterpriseregistration.windows.net",
      isAlias = false
    },
    {
      name    = "nhty6l3pj4xw4kj6tybz",
      record  = "verify.squarespace.com",
      isAlias = false
    },
    {
      name    = "selector1._domainkey",
      record  = "selector1-benchspace-co._domainkey.objectatelier.onmicrosoft.com",
      isAlias = false
    },
    {
      name    = "selector2._domainkey",
      record  = "selector2-benchspace-co._domainkey.objectatelier.onmicrosoft.com",
      isAlias = false
    },
    {
      name    = "www",
      record  = "ext-cust.squarespace.com",
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

module "bs-co-mtasts" {
  source                  = "./module/mtasts-v2"
  use-existing-front-door = true
  existing-front-door     = data.terraform_remote_state.web-server.outputs.whitefam-afd
  afd-resource-group      = data.terraform_remote_state.web-server.outputs.afd-resource-group
  dns-resource-group      = azurerm_resource_group.dnszones.name
  mx-records              = ["benchspace-co.mail.protection.outlook.com"]
  max-age                 = 86401
  domain-name             = azurerm_dns_zone.benchspace-co.name
  depends_on              = [azurerm_resource_group.cdnprofiles, azurerm_resource_group.dnszones]
  reporting-email         = "tls-reports@matthewjwhite.co.uk"
  stg-resource-group      = "RG-WhiteFam-UKS"
  resource-prefix         = "bsco"
  tags                    = local.tags
  permitted-ips           = local.permitted-ips
}
