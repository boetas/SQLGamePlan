output "RgName" {
  value = azurerm_resource_group.this.name
}

output "RgLocation" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.this.location
}
