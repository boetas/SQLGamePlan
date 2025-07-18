terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~> 1.12" # Or the latest version you want to use
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}

  subscription_id = var.AZURE_SUBSCRIPTION_ID
  client_id       = var.AZURE_CLIENT_ID
  client_secret   = var.AZURE_CLIENT_SECRET
  tenant_id       = var.AZURE_TENANT_ID
}

data "azurerm_client_config" "current" {}

module "ResourceGroup" {
  source    = "./resource-group"
  name = var.RESOURCE_GROUP_NAME
  location  = var.LOCATION
}

module "StorageAccount" {
  source                   = "./storage-account"
  base_name                = var.STORAGE_ACCOUNT_NAME
  location                 = var.LOCATION
  resource_group_name      = module.ResourceGroup.RgName
  account_tier             = var.STORAGE_ACCOUNT_TIER
  account_replication_type = var.STORAGE_ACCOUNT_REPLICATION_TYPE
  container_name           = var.STORAGE_ACCOUNT_CONTAINER_NAME
  container_access_type    = var.STORAGE_ACCOUNT_CONTAINER_ACCESS_TYPE
}

module "KeyVault" {
  source              = "./key-vault"
  name                = var.KEY_VAULT_NAME
  location            = var.LOCATION
  resource_group_name = module.ResourceGroup.RgName
  tenant_id           = var.AZURE_TENANT_ID
  object_id           = var.SPN_OBJECT_ID
  key_permissions     = ["Get"]
  secret_permissions  = ["Get"]
  storage_permissions = ["Get"]
}

module "vnet" {
  source = "./virtual-network"
  resource_group_name        = module.ResourceGroup.RgName
  location                   = var.LOCATION
  vnet_name                  = var.VNET_NAME
  aks_address_space          = var.AKS_ADDRESS_SPACE
  aks_subnet_name            = var.AKS_SUBNET_NAME
  aks_subnet_address_prefix  = var.AKS_SUBNET_ADDRESS_PREFIX
  appgw_subnet_name          = var.APPGW_SUBNET_NAME
  appgw_subnet_address_prefix= var.APPGW_SUBNET_ADDRESS_PREFIX
  arc_address_space          = var.ARC_ADDRESS_SPACE
  arc_subnet_name            = var.ARC_SUBNET_NAME
  arc_subnet_address_prefix  = var.ARC_SUBNET_ADDRESS_PREFIX
  agent_address_space        = var.AGENT_ADDRESS_SPACE
  agent_subnet_name          = var.AGENT_SUBNET_NAME
  agent_subnet_address_prefix= var.AGENT_SUBNET_ADDRESS_PREFIX
}

module "acr_private_endpoint" {
  source                    = "./private-arc"
  resource_group_name       = module.ResourceGroup.RgName
  location                  = var.LOCATION
  acr_name                  = var.ARC_NAME
  acr_sku                   = var.ARC_SKU
  arc_subnet_id             = module.vnet.arc_subnet_id
  arc_subnet_name           = module.vnet.arc_subnet_name
  vnet_id                   = module.vnet.vnet_id
  vnet_name                 = module.vnet.vnet_name
  dns_zone_id               = module.private-dns.dns_zone_id
  service_principal_display_name = var.SERVICE_PRINCICAL_NAME
}

module "app_gateway" {
  source               = "./application-gateway"
  subnet_name          = var.APPGW_SUBNET_NAME
  subnet_id            = module.vnet.appgw_subnet_id
  virtual_network_name = var.VNET_NAME
  resource_group_name  = module.ResourceGroup.RgName
  location             = var.LOCATION
  app_gateway_name     = var.APPGW_NAME
  public_ip_name       = var.APPGW_PUBLIC_IP_NAME
}

module "private-dns" {
  source = "./private-dns"
  resource_group_name = module.ResourceGroup.RgName
  dns_zone_scope      = var.DNS_ZONE_SCOPE
  vnet_id             = module.vnet.vnet_id
}

module "aks_cluster" {
  source = "./private-aks"
  subscription_id        = var.AZURE_SUBSCRIPTION_ID
  resource_group_name    = module.ResourceGroup.RgName
  location               = var.LOCATION
  name                   = var.AKS_NAME
  dns_prefix             = var.AKS_DNS_PREFIX
  kubernetes_version     = var.AKS_KUBERNETES_VERSION
  sku_tier               = var.AKS_SKU_TIER
  azure_policy_enabled   = false
  private_cluster_enabled = true

  default_node_pool_name         = "default"
  default_node_pool_vm_size      = "Standard_DS2_v2"
  default_node_pool_availability_zones = ["1", "2", "3"]
  default_node_pool_node_count   = 2
  default_node_pool_os_disk_type = "Managed"
  default_node_pool_labels       = {
    "nodepool-type" = "system"
    "environment"   = "dev"
    "nodepoolos"    = "linux"
    "app"           = "system-apps"
  }

  admin_username         = var.AKS_ADMIN_USER
  network_dns_service_ip = var.AKS_NETWORK_DNS_SERVICE_IP
  network_plugin         = var.AKS_NETWORK_PLUGIN
  network_service_cidr   = var.AKS_NETWORK_SERVICE_CIDR
  vnet_name              = module.vnet.vnet_name
  vnet_id                = module.vnet.vnet_id
  aks_subnet_name        = module.vnet.aks_subnet_name
  aks_subnet_id          = module.vnet.aks_subnet_id
  appgw_subnet_id        = module.vnet.appgw_subnet_id
  appgw_subnet_name      = module.vnet.appgw_subnet_name
  acr_id                 = module.acr_private_endpoint.acr_id
  acr_name               = module.acr_private_endpoint.acr_name
  app_gateway_id         = module.app_gateway.app_gateway_id
  app_gateway_name       = module.app_gateway.app_gateway_name
  dns_zone_scope         = var.DNS_ZONE_SCOPE
  dns_zone_id            = module.private-dns.dns_zone_id
  environment            = var.AKS_ENVIRONMENT
  user_node_pool_mode    = "User"
  user_linux_node_pool_name = "userlinux"
}

module "agent_vm" {
  source                        = "./agent-vm"
  resource_group_name           = module.ResourceGroup.RgName
  location                      = var.LOCATION
  vnet_name                     = var.VNET_NAME
  subnet_id                     = module.vnet.agent_subnet_id
  subnet_name                   = var.AGENT_SUBNET_NAME
  agent_subnet_address_prefix   = var.AGENT_SUBNET_ADDRESS_PREFIX
  vm_name                       = var.AGENT_VM_NAME
  vm_size                       = var.AGENT_VM_SIZE
  admin_username                = var.ADMIN_USERNAME
  admin_password                = var.ADMIN_PASSWORD
  name_prefix                   = var.AGENT_VM_NAME_PREFIX
  azdo_token                    = var.AZDO_TOKEN
}
