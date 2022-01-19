locals {
  server_names = ["test_server", "ci_server"]
}
resource "azurerm_dns_a_record" "basic_records" {
  for_each            = zipmap(local.server_names, var.ip_list)
  name                = each.key
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.group_name
  ttl                 = 300
  records             = [each.value]
}
