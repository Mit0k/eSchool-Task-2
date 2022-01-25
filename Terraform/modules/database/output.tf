output "host" {
  value = azurerm_mysql_server.database.name
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}