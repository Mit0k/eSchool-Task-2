locals {
  domain_name = "${var.domain}${var.parent_zone.name == "" ? "" : ".${var.parent_zone.name}"}"
}
resource "azurerm_dns_zone" "dns_zone" {
  name                = local.domain_name
  resource_group_name = var.group_name
}
