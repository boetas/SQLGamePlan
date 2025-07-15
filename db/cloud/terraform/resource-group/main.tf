resource "azurerm_resource_group" "this" {
  name     = "${var.base_name}-rg"
  location = var.location
}
