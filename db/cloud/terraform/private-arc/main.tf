# Create Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.acr_sku
  admin_enabled                 = false
  public_network_access_enabled = false

  network_rule_set {
    default_action = "Deny"

    ip_rule {
      action   = "Allow"
      ip_range = "13.0.0.0/16"
    }
  }
}

# Create Private DNS Zone
resource "azurerm_private_dns_zone" "acr_dns_zone" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
}

# Create Private Endpoint
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "${var.acr_name}-private-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.arc_subnet_id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.dns_zone_id]
  }

  private_service_connection {
    name                           = "${var.acr_name}-service-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}

# Create Virtual Network Links for each VNet to Private DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "${var.vnet_name}-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns_zone.name
  virtual_network_id    = var.vnet_id

  depends_on = [azurerm_private_dns_zone.acr_dns_zone]
}

# Get Azure AD service principal object id for role assignment
data "azuread_service_principal" "sp" {
  display_name = var.service_principal_display_name
}

# Assign AcrPush role to the service principal on the ACR
resource "azurerm_role_assignment" "acrpush_role" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = data.azuread_service_principal.sp.object_id
}
