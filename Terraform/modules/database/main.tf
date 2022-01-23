
### Creating DB
resource "azurerm_subnet" "internal" {
  name                 = "${var.project_name}-db-subnet"
  resource_group_name  = var.group_name
  virtual_network_name = var.vnet_data.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}
resource "azurerm_private_dns_zone" "main_zone" {
  name                = "${var.project_name}.mysql.database.azure.com"
  resource_group_name = var.group_name
}
resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "mysql-link"
  private_dns_zone_name = azurerm_private_dns_zone.main_zone.name
  virtual_network_id    = var.vnet_data.id
  resource_group_name   = var.group_name
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"

}

resource "azurerm_mysql_flexible_server" "mysql_db" {
  name                   = "mysql-${var.project_name}-tester"
  resource_group_name    = var.group_name
  location               = var.region
  administrator_login    = var.mysql_admin_login
  administrator_password = random_password.password.result
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.internal.id
  private_dns_zone_id    = azurerm_private_dns_zone.main_zone.id
  sku_name               = "B_Standard_B1s"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.link]
}

resource "azurerm_key_vault_secret" "mysql_database_password" {
  name         = "mysql-password"
  value        = random_password.password.result
  key_vault_id = var.keyvault_id
}

resource "azurerm_key_vault_secret" "mysql_database_connection" {
  name         = "mysql-connection-string"
  value        = "jdbc:mysql://${azurerm_mysql_flexible_server.mysql_db.name}.mysql.database.azure.com:3306/{your_database}?useSSL=false&requireSSL=false"
  key_vault_id = var.keyvault_id
}