resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.aks_address_space]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = [var.aks_subnet_address_prefix]

  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = var.appgw_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = [var.appgw_subnet_address_prefix]
}

resource "azurerm_virtual_network" "acr_vnet" {
  name                = var.acr_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.acr_address_space]

  subnet {
    name           = var.acr_subnet_name
    address_prefix = var.acr_subnet_address_prefix  
  }
}

resource "azurerm_virtual_network" "agent_vnet" {
  name                = var.agent_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.agent_address_space]

subnet {
  name           = var.agent_subnet_name
  address_prefix = var.agent_subnet_address_prefix
}
}

resource "azurerm_virtual_network_peering" "aks_acr" {
  name                      = "akstoacr"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.aks_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.acr_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "acr_aks" {
  name                      = "acrtoaks"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.acr_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.aks_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "acr_agent" {
  name                      = "acrtoagnet"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.acr_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.agent_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "agent_acr" {
  name                      = "agnettoacr"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.agent_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.acr_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "aks_agent" {
  name                      = "akstoagnet"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.aks_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.agent_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "agent_aks" {
  name                      = "agnettoaks"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.agent_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.aks_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}
