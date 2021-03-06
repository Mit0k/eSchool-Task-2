variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "group_name" {
  type = string
}

variable "domain" {
  type = string
}
variable "public_ip" {
  type = string
}
variable "public_ip_ID" {
  type = string
}

variable "parent_zone" {
  type = object({
    name  = string
    group = string
  })
}