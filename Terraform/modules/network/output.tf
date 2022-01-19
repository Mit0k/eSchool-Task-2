output "nic_test_server_id" {
  value = azurerm_network_interface.nic_list["test_server"].id
}

output "nic_ci_server_id" {
  value = azurerm_network_interface.nic_list["ci_server"].id
}

output "vnet_data" {
  value = { name = azurerm_virtual_network.vnet.name
      id   = azurerm_virtual_network.vnet.id }
}

output "public_ip_list" {
  value = [azurerm_public_ip.public_ip_list["test_server"].ip_address,
  azurerm_public_ip.public_ip_list["ci_server"].ip_address]
}