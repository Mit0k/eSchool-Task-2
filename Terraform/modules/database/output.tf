output "host" {
  value = "${azurerm_mysql_flexible_server.mysql_db.name}.${azurerm_private_dns_zone.main_zone.name}"
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}