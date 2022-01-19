data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                = "kv-${var.project_name}-${var.region}"
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
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }
}
