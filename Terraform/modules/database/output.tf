output "host" {
  value = "${azurerm_mysql_flexible_server.mysql_db.name}.mysql.database.azure.com"
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}