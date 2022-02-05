module "group" {
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
  public_ip    = module.network.public_fqdn
  public_ip_ID = module.network.public_ip_ID
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
  ssh_keys           = var.ssh_pubkey
}

module "database" {
  depends_on   = [module.servers]
  source       = "./modules/database"
  group_name   = module.group.resource_group_name
  project_name = var.project_name
  region       = var.region

  vnet_data         = module.network.vnet_data
  mysql_admin_login = var.mysql_admin_login
  keyvault_id       = module.key-vault.keyvault_id
  ip                = module.network.public_ip

}

resource "time_sleep" "wait" {
  depends_on = [module.servers]

  create_duration = "30s"
}
module "ansible" {
  depends_on = [time_sleep.wait]
  source     = "./modules/provisioner"

  fqdn         = module.dns_zone.fqdn
  ssh_path     = var.ssh_pubkey
  username     = var.username_prefix
  project_name = var.project_name
  db_admin     = var.mysql_admin_login
  db_password  = module.database.password
  host         = module.database.host
  group_name   = module.group.resource_group_name
  keyvault_id  = module.key-vault.keyvault_id
}