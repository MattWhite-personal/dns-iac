resource "azurerm_dns_zone" "mattandjen-co-uk" {
  name                = "mattandjen.co.uk"
  resource_group_name = azurerm_resource_group.dnszones.name
  tags                = local.tags
  lifecycle {
    prevent_destroy = true
  }
}

module "maj-records" {
  source       = "./module/dnsrecords"
  zone_name    = azurerm_dns_zone.mattandjen-co-uk.name
  rg_name      = azurerm_resource_group.dnszones.name
  tags         = local.tags
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
          value = "mailto:dnscaa@matthewjwhite.co.uk"
        }
      ]
    }
  ]
  cname-records = [
    {
      name    = "autodiscover",
      record  = "autodiscover.outlook.com",
      ttl     = 3600,
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
          exchange   = "mattandjen-co-uk.mail.protection.outlook.com"
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
      name    = "asuid.honeymoon",
      records = ["785BB65719041BA0A0ED39A14A41CC881653B01532783F9507B0C31FF2F54432"]
    },
    {
      name    = "asuid.honeymoonblog",
      records = ["785BB65719041BA0A0ED39A14A41CC881653B01532783F9507B0C31FF2F54432"],
      ttl     = 900
    }
  ]

}

module "maj-mtasts" {
  source                  = "./module/mtasts-v2"
  use-existing-front-door = true
  existing-front-door     = data.terraform_remote_state.web-server.outputs.whitefam-afd
  afd-resource-group      = data.terraform_remote_state.web-server.outputs.afd-resource-group
  dns-resource-group      = azurerm_resource_group.dnszones.name
  stg-resource-group      = "RG-WhiteFam-UKS"
  mx-records              = ["mattandjen-co-uk.mail.protection.outlook.com"]
  domain-name             = azurerm_dns_zone.mattandjen-co-uk.name
  depends_on              = [azurerm_resource_group.cdnprofiles, azurerm_resource_group.dnszones]
  reporting-email         = "tls-reports@matthewjwhite.co.uk"
  resource-prefix         = "maj"
  tags                    = local.tags
  runner-ip               = var.runner-ip
}

