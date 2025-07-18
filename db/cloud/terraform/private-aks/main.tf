terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.12"
    }
  }
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
  scope                = var.dns_zone_id
}

resource "azurerm_role_assignment" "Aks-AcrPull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.akscluster.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "app-gw-contributor" {
  scope                = var.app_gateway_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}

resource "azurerm_role_assignment" "app-gw-network-contributor" {
  scope                = var.appgw_subnet_id
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
  private_dns_zone_id       = var.dns_zone_id

  default_node_pool {
    name                   = var.default_node_pool_name
    vm_size                = var.default_node_pool_vm_size
    vnet_subnet_id         = var.aks_subnet_id
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
    gateway_id = var.app_gateway_id
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
  vnet_subnet_id         = var.aks_subnet_id
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