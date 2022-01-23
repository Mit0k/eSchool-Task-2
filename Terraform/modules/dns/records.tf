resource "azurerm_dns_cname_record" "basic_record" {
  name                = var.project_name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.group_name
  ttl                 = 300
  record             = var.public_ip
}
