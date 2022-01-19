
resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain
  resource_group_name = var.group_name
}
