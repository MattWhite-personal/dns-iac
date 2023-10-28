resource "azurerm_dns_zone" "tftest" {
  name                = "terraformtest.mattandjen.co.uk"
  resource_group_name = azurerm_resource_group.dnszones.name
}

module "maj-records" {
  source       = "./module/dnsrecords"
  zone_name    = azurerm_dns_zone.tftest.name
  rg_name      = azurerm_resource_group.dnszones.name
  a-records    = []
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
          value = "mailto:dndcaa@matthewjwhite.co.uk"
        }
      ]
    }
  ]
  cname-records = [
    {
      name    = "autodiscover",
      record  = "autodiscover.outlook.com",
      ttl     = 300,
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
      name    = "importtest",
      record  = "no.record.com",
      isAlias = false
    },
    {
      name    = "selector1-azurecomm-prod-net._domainkey",
      record  = "selector1-azurecomm-prod-net._domainkey.azurecomm.net",
      isAlias = false
    },
    {
      name    = "selector1._domainkey",
      record  = "selector1-mattandjen-co-uk._domainkey.thewhitefamily.onmicrosoft.com",
      isAlias = false
    },
    {
      name    = "selector2-azurecomm-prod-net._domainkey",
      record  = "selector2-azurecomm-prod-net._domainkey.azurecomm.net",
      isAlias = false
    },
    {
      name    = "selector2._domainkey",
      record  = "selector2-mattandjen-co-uk._domainkey.thewhitefamily.onmicrosoft.com",
      isAlias = false
    },
    {
      name    = "www",
      record  = "synthetic-weasel-gos6994em4n2r3i9byvbsrj2.herokudns.com",
      isAlias = false
    },
    {
      name    = "honeymoon",
      record  = "majhoneymoon.azurewebsites.net"
      ttl     = 900,
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
          exchange   = "test"
        },
        {
          preference = 5
          exchange   = "test2"
        }
      ]
    },
    {
      name = "test"
      ttl  = 300
      records = [
        {
          preference = 0
          exchange   = "test"
        },
        {
          preference = 5
          exchange   = "test2.domain.com"
        }
      ]
    }
  ]
  ptr-records = []
  srv-records = []
  txt-records = [
    {
      name = "@"
      records = [
        "MS=ms29779057",
        "v=spf1 include:spf.protection.outlook.com -all",
        "ms-domain-verification=cf4a15a4-3cbf-49e3-8184-147ff13af3f8"
      ]
      ttl = 300
    },
    {
      name = "_dmarc",
      records = [
        "v=DMARC1; p=quarantine; pct=50; rua=mailto:dmarc@matthewjwhite.co.uk; ruf=mailto:dmarc@matthewjwhite.co.uk; fo=1"
      ]
    },
    {
      name = "_mta-sts",
      records = [
        "v=STSv1; id=202112231408"
      ]
    },
    {
      name = "_smtp._tls",
      records = [
        "v=TLSRPTv1; rua=mailto:tls-reports@matthewjwhite.co.uk"
      ]
    },
    {
      name = "asuid.honeymoon",
      records = [
        "785BB65719041BA0A0ED39A14A41CC881653B01532783F9507B0C31FF2F54432"
      ]
    },
    {
      name = "asuid.honeymoonblog",
      records = [
        "785BB65719041BA0A0ED39A14A41CC881653B01532783F9507B0C31FF2F54432"
      ]
    }

  ]

}
/*
module "maj-mtasts" {
  source                   = "./module/mtasts"
  use-existing-cdn-profile = true
  existing-cdn-profile     = azurerm_cdn_profile.cdm-mta-sts.name
  resource_group           = azurerm_resource_group.cdnprofiles.name
  mx-records               = module.maj-records.mx-records.exchange
  domain-name              = azurerm_dns_zone.matthewjwhite-co-uk.name
}
*/
