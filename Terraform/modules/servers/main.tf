### Creating VM for Test Environment Server
#Create VM for testing
resource "tls_private_key" "tester_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

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
    public_key = tls_private_key.tester_ssh.public_key_openssh
    username   = var.username_prefix
  }
}


### Creating VM for CI Server
#Create VM for testing
resource "tls_private_key" "ci_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "ci_server" {
  name                = "vm-${var.project_name}-jenkins_server"
  computer_name       = "ci"
  resource_group_name = var.group_name
  location            = var.region
  size                = "Standard_A1_v2"
  admin_username      = "${var.username_prefix}ci"
  network_interface_ids = [
    var.nic_ci_server_id,
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
    public_key = tls_private_key.ci_ssh.public_key_openssh
    username   = "${var.username_prefix}ci"
  }
}


