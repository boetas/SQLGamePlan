output "public_ip_address" {
  value = data.azurerm_public_ip.public_ip_data.ip_address
}

output "azdo_token" {
  value     = var.azdo_token
  sensitive = true
}