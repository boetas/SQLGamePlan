terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.12"
    }
  }
}

# data sources
data "azurerm_application_gateway" "appgateway" {
  name                = var.app_gateway_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "aks-subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = var.aks_vnet_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "appgw-subnet" {
  name                 = var.appgw_subnet_name
  virtual_network_name = var.aks_vnet_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_virtual_network" "aks-vnet" {
  name                = var.aks_vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_virtual_network" "acr-vnet" {
  name                = var.acr_vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_virtual_network" "agent-vnet" {
  name                = var.agent_vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
}

# DNS zone
resource "azurerm_private_dns_zone" "aks" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  name                  = "pdzvnl-aks"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = data.azurerm_virtual_network.aks-vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks-acr" {
  name                  = "pdzvnl-aksacr"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = data.azurerm_virtual_network.acr-vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks-agent" {
  name                  = "pdzvnl-aksagent"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = data.azurerm_virtual_network.agent-vnet.id
}

# Identity
resource "azurerm_user_assigned_identity" "aks-access" {
  name                = "aks-access"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "dns_zone_contributor" {
  principal_id         = azurerm_user_assigned_identity.aks-access.principal_id
  role_definition_name = "Private DNS Zone Contributor"
  scope                = var.dns_zone_scope
}

resource "azurerm_role_assignment" "Aks-AcrPull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.akscluster.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "app-gw-contributor" {
  scope                = data.azurerm_application_gateway.appgateway.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}

resource "azurerm_role_assignment" "appgw-contributor" {
  scope                = data.azurerm_subnet.appgw-subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "akscluster" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  kubernetes_version        = var.kubernetes_version
  dns_prefix                = var.dns_prefix
  private_cluster_enabled   = var.private_cluster_enabled
  sku_tier                  = var.sku_tier
  azure_policy_enabled      = var.azure_policy_enabled
  private_dns_zone_id       = azurerm_private_dns_zone.aks.id

  default_node_pool {
    name                   = var.default_node_pool_name
    vm_size                = var.default_node_pool_vm_size
    vnet_subnet_id         = data.azurerm_subnet.aks-subnet.id
    zones                  = var.default_node_pool_availability_zones
    node_count             = var.default_node_pool_node_count
    os_disk_type           = var.default_node_pool_os_disk_type
    node_labels            = var.default_node_pool_labels
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks-access.id]
  }

  ingress_application_gateway {
    gateway_id = data.azurerm_application_gateway.appgateway.id
  }

  network_profile {
    dns_service_ip    = var.network_dns_service_ip
    network_plugin    = var.network_plugin
    service_cidr      = var.network_service_cidr
    load_balancer_sku = "standard"
  }
}

# Create Linux Azure AKS Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "linux101" {
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.akscluster.id
  name                   = var.user_linux_node_pool_name
  mode                   = var.user_node_pool_mode
  vm_size                = var.default_node_pool_vm_size
  vnet_subnet_id         = data.azurerm_subnet.aks-subnet.id
  zones                  = var.default_node_pool_availability_zones
  #max_pods               = var.default_node_pool_max_pods
  #max_count    = "1"
  #min_count    = "1"
  node_count   = var.default_node_pool_node_count
  os_disk_type = var.default_node_pool_os_disk_type
  node_labels = {
    "nodepool-type" = var.user_linux_node_pool_name
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "app"           = "user-apps"
  }

}