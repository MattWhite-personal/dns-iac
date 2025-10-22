locals {
  tls_rpt_email  = length(split("@", var.reporting-email)) == 2 ? var.reporting-email : "${var.reporting-email}@${var.domain-name}"
  policyhash     = md5("${var.mtastsmode},${join(",", var.mx-records)},var.max-age")
  afd-prefix     = "cdn${var.resource-prefix}mtasts"
  storage_prefix = coalesce(var.resource-prefix, substr(replace(local.afd-prefix, "-", ""), 0, 16))
  afd-version = {
    "standard" = "Standard_AzureFrontDoor",
    "premium"  = "Premium_AzureFrontDoor",
    "default"  = "Standard_AzureFrontDoor"
  }
  front-door-id = var.use-existing-front-door ? data.azurerm_cdn_frontdoor_profile.afd[0].id : azurerm_cdn_frontdoor_profile.mta-sts[0].id
  storage-account-name = "stmtasts${local.storage_prefix}"
}
