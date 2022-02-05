data "azurerm_client_config" "current" {}

resource "random_integer" "kv_suffix_gen" {
  min = 100
  max = 999
}

resource "azurerm_key_vault" "keyvault" {
  name                = "kv-${var.project_name}${random_integer.kv_suffix_gen.result}"
  location            = var.region
  resource_group_name = var.group_name

  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "list",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }
}
