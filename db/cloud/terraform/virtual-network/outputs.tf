output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "agent_subnet_id" {
  value = azurerm_subnet.agent_subnet.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "aks_subnet_name" {
  value = azurerm_subnet.aks_subnet.name
}

output "arc_subnet_id" {
  value = azurerm_subnet.arc_subnet.id
}

output "arc_subnet_name" {
  value = azurerm_subnet.arc_subnet.name
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw_subnet.id
}

output "appgw_subnet_name" {
  value = azurerm_subnet.appgw_subnet.name
}
