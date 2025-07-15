output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "acr_private_endpoint_id" {
  value = azurerm_private_endpoint.acr_private_endpoint.id
}

output "acr_private_dns_zone_id" {
  value = azurerm_private_dns_zone.acr_dns_zone.id
}
