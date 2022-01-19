variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "group_name" {
  type = string
}
variable "mysql_admin_login" {
  type = string
}
variable "keyvault_id" {
  type    = string
  default = ""
}

variable "vnet_data" {
  type = object({
    name = string,
    id   = string
  })
}