### Security rules for TEST SERVER
# TODO: Refactoring
locals {
  nsg_rules = {
    "allow_https" = { priority = 100, port_range = 433, protocol = "tcp" },
    "allow_http"  = { priority = 104, port_range = 80, protocol = "tcp" },
    "allow_ssh"   = { priority = 102, port_range = 22, protocol = "tcp" },
    "allow_icmp"  = { priority = 101, port_range = "*", protocol = "icmp" }
  }
}


resource "azurerm_network_security_rule" "nsg-tester_server-config" {
  for_each = local.nsg_rules

  name                        = each.key
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = each.value.protocol
  source_port_range           = "*"
  destination_port_range      = each.value.port_range
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.group_name
  network_security_group_name = azurerm_network_security_group.firewall_rules["test_server"].name
}
resource "azurerm_network_security_rule" "nsg-ci_server-config" {
  for_each = local.nsg_rules

  name                        = each.key
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = each.value.protocol
  source_port_range           = "*"
  destination_port_range      = each.value.port_range
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.group_name
  network_security_group_name = azurerm_network_security_group.firewall_rules["ci_server"].name
}