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
  base_name = "k8s"
  location  = "South Africa North"
}

module "StorageAccount" {
  source                   = "./storage-account"
  base_name                = "k8sstorage22220022"
  location                 = module.ResourceGroup.RgLocation
  resource_group_name      = module.ResourceGroup.RgName
  account_tier             = "Standard"
  account_replication_type = "LRS"
  container_name           = "tfstates"
  container_access_type    = "private"
}

module "KeyVault" {
  source              = "./key-vault"
  name                = "secret-vault-100"
  location            = module.ResourceGroup.RgLocation
  resource_group_name = module.ResourceGroup.RgName
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id

  key_permissions     = ["Get"]
  secret_permissions  = ["Get"]
  storage_permissions = ["Get"]
}

module "vnet" {
  source = "./virtual-network"

  resource_group_name        = module.ResourceGroup.RgName
  location                   = module.ResourceGroup.RgLocation

  aks_vnet_name              = var.AKS_VNET_NAME
  aks_address_space          = var.AKS_ADDRESS_SPACE
  aks_subnet_name            = var.AKS_SUBNET_NAME
  aks_subnet_address_prefix  = var.AKS_SUBNET_ADDRESS_PREFIX
  appgw_subnet_name          = var.APPGW_SUBNET_NAME
  appgw_subnet_address_prefix= var.APPGW_SUBNET_ADDRESS_PREFIX

  acr_vnet_name              = var.ACR_VNET_NAME
  acr_address_space          = var.ACR_ADDRESS_SPACE
  acr_subnet_name            = var.ACR_SUBNET_NAME
  acr_subnet_address_prefix  = var.ACR_SUBNET_ADDRESS_PREFIX

  agent_vnet_name            = var.AGENT_VNET_NAME
  agent_address_space        = var.AGENT_ADDRESS_SPACE
  agent_subnet_name          = var.AGENT_SUBNET_NAME
  agent_subnet_address_prefix= var.AGENT_SUBNET_ADDRESS_PREFIX
}

module "acr_private_endpoint" {
  source                    = "./private-arc"
  resource_group_name       = module.ResourceGroup.RgName
  location                  = module.ResourceGroup.RgLocation
  acr_name                  = "k8sacr22022"
  acr_sku                   = "Premium"
  vnet_names                = ["acr-vnet", "agent-vnet", "aks-vnet"]
  subnet_name               = "acr-subnet"
  service_principal_display_name = "sp-devops-practice"
}

module "app_gateway" {
  source              = "./application-gateway"
  subnet_name         = "appgw-subnet"
  virtual_network_name = var.VIRTUAL_NETWORK_NAME
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  app_gateway_name    = "myAppGw"
  public_ip_name      = "myAppGwPublicIP"
}

module "aks_cluster" {
  source = "./private-aks"

  subscription_id        = var.AZURE_SUBSCRIPTION_ID
  resource_group_name    = module.ResourceGroup.RgName
  location               = module.ResourceGroup.RgLocation
  name                   = "myaks"
  dns_prefix             = "myaks"
  kubernetes_version     = "1.33.0"
  sku_tier               = "Free"
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

  admin_username         = "azureuser"
  network_dns_service_ip = "10.0.0.10"
  network_plugin         = "azure"
  network_service_cidr   = "10.0.0.0/16"

  aks_subnet_name        = "aks-subnet"
  aks_vnet_name          = "aks-vnet"
  acr_vnet_name          = "acr-vnet"
  agent_vnet_name        = "agent-vnet"
  appgw_subnet_name      = "appgw-subnet"

  acr_name               = module.acr_private_endpoint.acr_name
  app_gateway_name       = module.app_gateway.app_gateway_name

  dns_zone_name          = "private.southafricanorth.azmk8s.io"
  dns_zone_scope         = "/subscriptions/${var.AZURE_SUBSCRIPTION_ID}/resourceGroups/k8s-rg/providers/Microsoft.Network/privateDnsZones/private.southafricanorth.azmk8s.io"

  environment            = "dev"
  user_node_pool_mode    = "User"
  user_linux_node_pool_name = "userlinux"
}

module "agent_vm" {
  source              = "./agent-vm"
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  vnet_name           = "agent-vnet"
  subnet_name         = "agent-subnet"
  vm_name             = "agent-vm"
  vm_size             = "Standard_B2ms"
  admin_username      = "prime"
  admin_password      = "P@ssw0rdP@ssw0rd"
  name_prefix         = "agent"
}
