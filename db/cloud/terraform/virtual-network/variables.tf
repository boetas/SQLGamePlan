variable "resource_group_name" { type = string }
variable "location" { type = string }

variable "vnet_name" { type = string }

variable "aks_subnet_name" { type = string }
variable "appgw_subnet_name" { type = string }
variable "arc_subnet_name" { type = string }
variable "agent_subnet_name" { type = string }

variable "aks_address_space" { type = string }
variable "arc_address_space" { type = string }
variable "agent_address_space" { type = string }
variable "aks_subnet_address_prefix" { type = string }

variable "appgw_subnet_address_prefix" { type = string }
variable "arc_subnet_address_prefix" { type = string }
variable "agent_subnet_address_prefix" { type = string }