resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-${var.region}"
  location = var.region
}