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
  public_ip    = module.network.public_ip
  parent_zone  = var.parent_zone
}
#Module 'server'
module "servers" {
  source = "./modules/servers"

  group_name      = module.group.resource_group_name
  project_name    = var.project_name
  region          = var.region
  username_prefix = var.username_prefix

  nic_test_server_id = module.network.nic_test_server_id
  ssh_keys           = var.ssh_keys
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

module "ansible" {
  source = "./modules/provisioner"

  fqdn             = module.network.public_ip
  ssh_path         = var.ssh_keys
  username         = var.username_prefix
  project_name     = var.project_name
  db_admin         = var.mysql_admin_login
  db_password      = module.database.password
  host             = module.database.host
  project_db_creds = var.project_db_creds
}