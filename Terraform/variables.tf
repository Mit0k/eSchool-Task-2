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
  description = "mysql admin login"
  type        = string
}
variable "mysql_admin_password" {
  description = "mysql admin password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "domain" {
  description = "domain for project site"
  type        = string
}

variable "ssh_pubkey" {
  description = "Public key (SSH)"
  type        = string
}

variable "parent_zone" {
  description = "Parent DNS zone for domain"
  type = object({
    name  = string
    group = string
  })
}