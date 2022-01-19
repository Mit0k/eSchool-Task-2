###Creating Virtual Network and configuring it
#Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}-${var.region}"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = var.group_name
}
#Plus subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.project_name}-internal-subnet"
  resource_group_name  = var.group_name
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  service_endpoints    = ["Microsoft.Storage"]
}


### Dynamically configured resources
locals {
  server_names = ["test_server", "ci_server"]
}
# Public IP for VM`s
resource "azurerm_public_ip" "public_ip_list" {
  for_each            = toset(local.server_names)
  name                = "pip-${var.project_name}-${each.value}-${var.region}"
  resource_group_name = var.group_name
  location            = var.region
  allocation_method   = "Static"
}
# NIC
resource "azurerm_network_interface" "nic_list" {
  for_each = toset(local.server_names)

  name                = "vm-${var.project_name}-${each.value}"
  location            = var.region
  resource_group_name = var.group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_list[each.value].id
  }
}
# Network security groups (Security rules written in security_rules.tf)
resource "azurerm_network_security_group" "firewall_rules" {
  for_each = toset(local.server_names)

  name                = "nsg-${each.value}"
  location            = var.region
  resource_group_name = var.group_name

}
# And finally associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "firewall_association" {
  for_each                  = toset(local.server_names)
  network_interface_id      = azurerm_network_interface.nic_list[each.value].id
  network_security_group_id = azurerm_network_security_group.firewall_rules[each.value].id
}