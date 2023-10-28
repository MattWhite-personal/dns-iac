
resource "azurerm_dns_mx_record" "mx" {
  for_each = {
    for record in var.mx-records : record.name => record
  }
  name                = each.value["name"]
  zone_name           = var.zone_name
  resource_group_name = var.rg_name
  ttl                 = coalesce(each.value["ttl"], var.ttl)

  dynamic "record" {
    for_each = lookup(each.value, "records", null)
    content {
      preference = record.value["preference"]
      exchange   = record.value["exchange"]
    }
  }


}

resource "azurerm_dns_txt_record" "txt" {
  for_each = {
    for record in var.txt-records : record.name => record
  }
  name                = each.value["name"]
  zone_name           = var.zone_name
  resource_group_name = var.rg_name
  ttl                 = coalesce(each.value["ttl"], var.ttl)

  dynamic "record" {
    for_each = each.value["records"]
    content {
      value = record.value
    }
  }
}

resource "azurerm_dns_cname_record" "cname" {
  for_each = {
    for record in var.cname-records : record.name => record
  }
  name                = each.value["name"]
  zone_name           = var.zone_name
  resource_group_name = var.rg_name
  ttl                 = coalesce(each.value["ttl"], var.ttl)
  record              = each.value["isAlias"] ? null : each.value["record"]
  target_resource_id  = each.value["isAlias"] ? each.value["resourceID"] : null
}

resource "azurerm_dns_caa_record" "caa" {
  for_each = {
    for record in var.caa-records : record.name => record
  }
  name                = each.value["name"]
  zone_name           = var.zone_name
  resource_group_name = var.rg_name
  ttl                 = coalesce(each.value["ttl"], var.ttl)

  dynamic "record" {
    for_each = each.value["records"]
    content {
      flags = record.value["flags"]
      tag   = record.value["tag"]
      value = record.value["value"]
    }
  }
}
