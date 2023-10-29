resource "azurerm_dns_zone" "objectatelier-co-uk" {
  name                = "objectatelier.co.uk"
  resource_group_name = azurerm_resource_group.dnszones.name
  lifecycle {
    prevent_destroy = true
  }
}

module "oa-records" {
  source    = "./module/dnsrecords"
  zone_name = azurerm_dns_zone.objectatelier-co-uk.name
  rg_name   = azurerm_resource_group.dnszones.name
  tags = local.tags
  a-records = [
    {
      name    = "@",
      records = ["51.104.28.83"],
      isAlias = false
      ttl     = 60
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
      name    = "_domainconnect",
      record  = "_domainconnect.gd.domaincontrol.com.",
      isAlias = false
    },
    {
      name    = "autodiscover",
      record  = "autodiscover.outlook.com.",
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
      name    = "msoid",
      record  = "clientconfig.microsoftonline-p.net.",
      isAlias = false
    },
    {
      name    = "newsite",
      record  = "objectatelier.azurewebsites.net",
      isAlias = false
    },
    {
      name    = "selector1-azurecomm-prod-net._domainkey",
      record  = "selector1-azurecomm-prod-net._domainkey.azurecomm.net",
      isAlias = false
    },
    {
      name    = "selector1._domainkey",
      record  = "selector1-objectatelier-co-uk._domainkey.objectatelier.onmicrosoft.com",
      isAlias = false
    },
    {
      name    = "selector2-azurecomm-prod-net._domainkey",
      record  = "selector2-azurecomm-prod-net._domainkey.azurecomm.net",
      isAlias = false
    },
    {
      name    = "selector2._domainkey",
      record  = "selector2-objectatelier-co-uk._domainkey.objectatelier.onmicrosoft.com",
      isAlias = false
    },
    {
      name    = "sip",
      record  = "sipdir.online.lync.com.",
      isAlias = false
    },
    {
      name    = "www",
      record  = "objectatelier.azurewebsites.net",
      isAlias = false
      ttl     = 60
    }

  ]
  mx-records = [
    {
      name = "@"
      ttl  = 3600
      records = [
        {
          preference = 0
          exchange   = "objectatelier-co-uk.mail.protection.outlook.com."
        }
      ]
    }
  ]
  ptr-records = []
  srv-records = []
  txt-records = [
    {
      name    = "_dmarc",
      records = ["v=DMARC1; p=quarantine; pct=50; rua=mailto:dmarc@matthewjwhite.co.uk; ruf=mailto:dmarc@matthewjwhite.co.uk; fo=1"]
    },
    {
      name    = "asuid",
      records = ["785BB65719041BA0A0ED39A14A41CC881653B01532783F9507B0C31FF2F54432"]
    },
    {
      name    = "asuid.newsite",
      records = ["785BB65719041BA0A0ED39A14A41CC881653B01532783F9507B0C31FF2F54432"]
    },
    {
      name    = "asuid.www",
      records = ["785BB65719041BA0A0ED39A14A41CC881653B01532783F9507B0C31FF2F54432"]
    },
    {
      name = "@",
      records = [
        "google-site-verification=UuLhdMHYJjVRhgEnshou6NHQSr4j_n0CqTETDwpmCrA",
        "v=spf1 include:spf.protection.outlook.com -all",
        "ms-domain-verification=a1b58344-519b-41ae-9d39-ab122d64e909"
      ]
    }

  ]

}

/*
module "oa-mtasts" {
  source                   = "./module/mtasts"
  use-existing-cdn-profile = true
  existing-cdn-profile     = azurerm_cdn_profile.cdm-mta-sts.name
  cdn-resource-group       = azurerm_resource_group.cdnprofiles.name
  dns-resource-group       = azurerm_resource_group.dnszones.name
  mx-records               = ["objectatelier-co-uk.mail.protection.outlook.com"]
  domain-name              = azurerm_dns_zone.objectatelier-co-uk.name
  depends_on               = [azurerm_resource_group.cdnprofiles, azurerm_resource_group.dnszones]
  REPORTING_EMAIL          = "tls-reports@matthewjwhite.co.uk"
}
*/
