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
variable "ip_suffix" {
  default = ""
}
resource "random_id" "ip_suffix_gen" {
  byte_length = 8
  keepers = {
    ip_suffix = var.ip_suffix
  }
}
# Public IP for VM`s
resource "azurerm_public_ip" "public_ip" {
  name                = "pip-${var.project_name}-${var.project_name}-${var.region}"
  resource_group_name = var.group_name
  location            = var.region
  allocation_method   = "Dynamic"
  domain_name_label = "eschool${random_id.ip_suffix_gen.keepers.ip_suffix}"

}
# NIC
resource "azurerm_network_interface" "nic" {

  name                = "vm-${var.project_name}-${var.project_name}"
  location            = var.region
  resource_group_name = var.group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}
# Network security groups (Security rules written in security_rules.tf)
resource "azurerm_network_security_group" "firewall_rules" {

  name                = "nsg-${var.project_name}"
  location            = var.region
  resource_group_name = var.group_name

}
# And finally associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "firewall_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.firewall_rules.id
}