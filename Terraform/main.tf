#Module 'group'::: Create resource group OR use the existing one if variable resource_group_name is set
module "group" {
  #count  = module.group.resource_group_name == "" ? 1 : 0
  source = "./modules/group"

  project_name = var.project_name
  region       = var.region
}

#Module 'key vault'
module "key-vault" {

  source = "./modules/keyvault"

  group_name   = module.group.resource_group_name
  project_name = var.project_name
  region       = var.region
}

#Module 'network'
module "network" {
  source = "./modules/network"

  group_name   = module.group.resource_group_name
  project_name = var.project_name
  region       = var.region
}
#Module 'DNS'
module "dns_zone" {
  source = "./modules/dns"

  group_name   = module.group.resource_group_name
  project_name = var.project_name
  region       = var.region
  domain       = var.domain
  ip_list      = module.network.public_ip_list
}
#Module 'server'
module "servers" {
  source = "./modules/servers"

  group_name      = module.group.resource_group_name
  project_name    = var.project_name
  region          = var.region
  username_prefix = var.username_prefix

  nic_test_server_id = module.network.nic_test_server_id
  nic_ci_server_id   = module.network.nic_ci_server_id
}

module "database" {
  source       = "./modules/database"
  group_name   = module.group.resource_group_name
  project_name = var.project_name
  region       = var.region

  vnet_data         = module.network.vnet_data
  mysql_admin_login = var.mysql_admin_login
  keyvault_id       = module.key-vault.keyvault_id


}