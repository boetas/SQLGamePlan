resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [
    var.aks_address_space,
    var.arc_address_space,
    var.appgw_subnet_address_prefix,
    var.agent_address_space 
  ]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_subnet_address_prefix]

  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "arc_subnet" {
  name                 = var.arc_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.arc_subnet_address_prefix]

  service_endpoints = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = var.appgw_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.appgw_subnet_address_prefix]
}

resource "azurerm_subnet" "agent_subnet" {
  name                 = var.agent_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.agent_subnet_address_prefix]
}
