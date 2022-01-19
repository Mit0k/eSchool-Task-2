variable "region" {
  description = "Region in which project will be deployed"
  type        = string
  default     = "westus"
}

variable "project_name" {
  description = "Name of project"
  type        = string
  default     = "eschool-terra"
}

variable "resource_group_name" {
  description = "Left unfilled if you want to create a new group"
  type        = string
  default     = ""
}

variable "server_names" {
  type    = list(string)
  default = ["test_server", "ci_server"]
}

variable "username_prefix" {
  description = "admin username prefix"
  type        = string
  default     = "mitok"
}

variable "mysql_admin_login" {
  default = "psqladmin"
}
variable "mysql_admin_password" {
  default = "H@Sh1CoR3!"
}
variable "vnet_data" {
  type = object({
    name = string,
    id   = string
  })
  default = {name = "", id = ""}
}

variable "domain" {
  type    = string
  default = "terra-mitok.com"
}