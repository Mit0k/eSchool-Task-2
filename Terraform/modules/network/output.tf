output "nic_test_server_id" {
  value = azurerm_network_interface.nic.id
}


output "vnet_data" {
  value = {
    name = azurerm_virtual_network.vnet.name
    id   = azurerm_virtual_network.vnet.id
  }
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}
output "public_fqdn" {
  value = azurerm_public_ip.public_ip.fqdn
}

output "public_ip_ID" {
  value = azurerm_public_ip.public_ip.id
}