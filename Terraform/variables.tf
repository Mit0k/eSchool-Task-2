variable "region" {
  description = "Region in which project will be deployed"
  type        = string
}

variable "project_name" {
  description = "Name of project"
  type        = string
}

variable "resource_group_name" {
  description = "Left unfilled if you want to create a new group"
  type        = string
}

variable "username_prefix" {
  description = "admin username prefix"
  type        = string
}

variable "mysql_admin_login" {
  type = string
}
variable "mysql_admin_password" {
  type      = string
  sensitive = true
}

#TODO : Validate
variable "domain" {
  type = string
}

variable "ssh_keys" {
  type = string
}

variable "parent_zone" {
  type = object({
    name  = string
    group = string
  })
}