
resource "random_pet" "server" {
  length = 1
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"

}

resource "azurerm_mysql_server" "database" {
  name                = "sdb-${var.project_name}-${random_pet.server.id}"
  location            = var.region
  resource_group_name = var.group_name

  administrator_login          = var.mysql_admin_login
  administrator_login_password = random_password.password.result
  ssl_enforcement_enabled           = false

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"
}

resource "azurerm_mysql_firewall_rule" "firewall" {
  name                = "FirewallRule1"
  resource_group_name = var.group_name
  server_name         = azurerm_mysql_server.database.name
  start_ip_address    = var.ip
  end_ip_address      = var.ip
}

resource "azurerm_key_vault_secret" "mysql_database_password" {
  name         = "mysql-password-${var.group_name}"
  value        = random_password.password.result
  key_vault_id = var.keyvault_id
}
