variable "fqdn" {
  type = string
}
variable "ssh_path" {
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
variable "project_db_creds" {
  type = object({
    dbname   = string
    username = string
    password = string
  })
}