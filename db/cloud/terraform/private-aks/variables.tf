variable "resource_group_name" {}
variable "location" {}
variable "subscription_id" {}
variable "name" {}
variable "dns_prefix" {}
variable "kubernetes_version" {}
variable "sku_tier" {}
variable "azure_policy_enabled" {}
variable "private_cluster_enabled" {}

variable "default_node_pool_name" {}
variable "default_node_pool_vm_size" {}
variable "default_node_pool_availability_zones" {
  type = list(string)
}
variable "default_node_pool_node_count" {}
variable "default_node_pool_os_disk_type" {}
variable "default_node_pool_labels" {
  type = map(string)
}

variable "admin_username" {}

variable "network_dns_service_ip" {}
variable "network_plugin" {}
variable "network_service_cidr" {}

variable "vnet_name" {}
variable "vnet_id" {}
variable "aks_subnet_id" {}
variable "aks_subnet_name" {}
variable "appgw_subnet_id" {}
variable "appgw_subnet_name" {}
variable "acr_id" {}
variable "acr_name" {}
variable "app_gateway_id" {}
variable "app_gateway_name" {}
variable "dns_zone_scope" {}
variable "dns_zone_id" {}

variable "user_linux_node_pool_name" {}
variable "user_node_pool_mode" {}
variable "environment" {}