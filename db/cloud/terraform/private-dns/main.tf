# DNS zone
resource "azurerm_private_dns_zone" "aks" {
  name                = var.dns_zone_scope
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  name                  = "pdzvnl-aks"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = var.vnet_id
}
