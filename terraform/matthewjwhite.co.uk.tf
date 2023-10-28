resource "azurerm_dns_zone" "matthewjwhite-co-uk" {
  name                = "testmatthewjwhite.co.uk"
  resource_group_name = azurerm_resource_group.dnszones.name
}

module "mjw-records" {
  source    = "./module/dnsrecords"
  zone_name = azurerm_dns_zone.matthewjwhite-co-uk.name
  rg_name   = azurerm_resource_group.dnszones.name
  mx-records = [
    {
      name = "@"
      ttl  = 3600
      records = [
        {
          preference = 0
          exchange   = "matthewjwhite-co-uk.mail.protection.outlook.com."
        }
      ]
    }
  ]
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
      record  = "autodiscover.outlook.com.",
      isAlias = false
    },
    {
      name    = "cdnverify.mta-sts",
      record  = "cdnverify.mjwmtasts.azureedge.net",
      isAlias = false
    },
    {
      name    = "d7f095024217c24089a3adf793728469",
      record  = "verify.bing.com.",
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
      name    = "leatherhead",
      record  = "mail.matthewjwhite.co.uk.",
      isAlias = false
    },
    {
      name    = "lyncdiscover",
      record  = "webdir.online.lync.com.",
      isAlias = false
    },
    {
      name    = "mailgate",
      record  = "mail.matthewjwhite.co.uk.",
      isAlias = false
    },
    {
      name    = "msoid",
      record  = "clientconfig.microsoftonline-p.net.",
      isAlias = false
    },
    {
      name    = "newsite",
      record  = "mjwsite.azurewebsites.net",
      isAlias = false
    },
    {
      name    = "selector1-azurecomm-prod-net._domainkey",
      record  = "selector1-azurecomm-prod-net._domainkey.azurecomm.net",
      isAlias = false
    },
    {
      name    = "selector1._domainkey",
      record  = "selector1-matthewjwhite-co-uk._domainkey.thewhitefamily.onmicrosoft.com.",
      isAlias = false
    },
    {
      name    = "selector2-azurecomm-prod-net._domainkey",
      record  = "selector2-azurecomm-prod-net._domainkey.azurecomm.net",
      isAlias = false
    },
    {
      name    = "selector2._domainkey",
      record  = "selector2-matthewjwhite-co-uk._domainkey.thewhitefamily.onmicrosoft.com.",
      isAlias = false
    },
    {
      name    = "sip",
      record  = "sipdir.online.lync.com.",
      isAlias = false
    },
    {
      name    = "www",
      record  = "matthewjwhite.co.uk.",
      isAlias = false
    }

  ]
  txt-records = [
    {
      name    = "_dmarc",
      records = ["v=DMARC1; p=quarantine; pct=50; rua=mailto:dmarc@matthewjwhite.co.uk; ruf=mailto:dmarc@matthewjwhite.co.uk; fo=1"]
    },
    {
      name    = "_dnsauth.fd",
      records = ["gjjyl16msb6l95zvjnhxv1nzf6ldxsck"]
    },
    {
      name    = "_dnsauth.fdoor",
      records = ["5j22clbbcf3gzs95t92xr14ykh1s0jdl"]
    },
    {
      name    = "_mta-sts",
      records = ["v=STSv1; id=202112081700"]
    },
    {
      name    = "_smtp._tls",
      records = ["v=TLSRPTv1; rua=mailto:tls-reports@matthewjwhite.co.uk"]
    },
    {
      name    = "asuid.newsite",
      records = ["785BB65719041BA0A0ED39A14A41CC881653B01532783F9507B0C31FF2F54432"]
    },
    {
      name = "@",
      records = [
        "v=spf1 include:spf.protection.outlook.com a:www.matthewjwhite.co.uk -all",
        "MS=ms65196555",
        "google-site-verification=1UJCslKGjOU26wgnB_rnNY9WyQaXxxyNRHQxQqxFBPY",
        "ms-domain-verification=d8300c96-c9ba-4569-a0f9-469cbc585614"
      ]
    }
  ]
  a-records = [
    {
      name    = "ha",
      records = ["90.196.227.99"],
      isAlias = false
    },
    {
      name    = "localhost",
      records = ["127.0.0.1"],
      isAlias = false
    },
    {
      name    = "mail",
      records = ["81.174.249.251"],
      isAlias = false
    },
    {
      name    = "vpn",
      records = ["5.64.45.6"],
      isAlias = false
    }

  ]
  aaaa-records = []
  srv-records  = []
  ptr-records  = []
}
