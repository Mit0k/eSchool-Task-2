### Creating VM for Test Environment Server
#Create VM for testing
resource "azurerm_linux_virtual_machine" "test_server" {
  name                = "vm-${var.project_name}-test_server"
  computer_name       = "tester"
  resource_group_name = var.group_name
  location            = var.region
  size                = "Standard_A1_v2"
  admin_username      = var.username_prefix
  network_interface_ids = [
    var.nic_test_server_id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"

  }

  admin_ssh_key {
    public_key = file(var.ssh_keys)
    username   = var.username_prefix
  }
}

