variable "fqdn" {
  type = string
}
variable "ssh_path" {
  type = string
}
variable "group_name" {
  type = string
}
variable "username" {
  type = string
}
variable "project_name" {
  type = string
}
variable "db_admin" {
  type = string
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "host" {
  type = string
}
variable "keyvault_id" {
  type = string
}