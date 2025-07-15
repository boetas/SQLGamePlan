variable "resource_group_name" {type = string}
variable "location" {type = string}
variable "acr_name" {type = string}
variable "acr_sku" {type = string}
variable "vnet_names" {type = list(string)}
variable "subnet_name" {type = string}
variable "service_principal_display_name" {type = string}
