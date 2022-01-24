
resource "azurerm_dns_cname_record" "basic_record" {
  name                = var.parent_zone.name == "" ? var.project_name : "*"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.group_name
  ttl                 = 300
  record              = var.public_ip
}

resource "azurerm_dns_ns_record" "make_childzone" {
  count               = var.parent_zone.name == "" ? 0 : 1
  name                = var.domain
  zone_name           = var.parent_zone.name
  resource_group_name = var.parent_zone.group
  ttl                 = 60

  records = azurerm_dns_zone.dns_zone.name_servers
}