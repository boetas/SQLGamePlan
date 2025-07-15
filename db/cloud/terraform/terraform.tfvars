# ACR variables
ACR_SKU                     = "Premium"
ACR_NAME                     = "k8sacr22022"

# AKS (Azure Kubernetes Service) related variables
AKS_VNET_NAME               = "aks-vnet"
AKS_ADDRESS_SPACE           = "11.0.0.0/12"
AKS_SUBNET_NAME             = "aks-subnet"
AKS_SUBNET_ADDRESS_PREFIX   = "11.0.0.0/16"

# Application Gateway (AppGW) related variables
APPGW_SUBNET_NAME           = "appgw-subnet"
APPGW_SUBNET_ADDRESS_PREFIX = "11.1.0.0/24"

# Location and Resource Group
LOCATION                    = "South Africa North"
RESOURCE_GROUP_NAME          = "k8s-rg"

# Azure Container Registry (ACR) related variables
ACR_VNET_NAME               = "acr-vnet"
ACR_SUBNET_NAME             = "acr-subnet"
ACR_SUBNET_ADDRESS_PREFIX   = "12.0.0.0/16"
ACR_ADDRESS_SPACE           = "12.0.0.0/16"

# Agent related variables (for VMs or other agents)
AGENT_VNET_NAME             = "agent-vnet"
AGENT_SUBNET_NAME           = "agent-subnet"
AGENT_SUBNET_ADDRESS_PREFIX = "13.0.0.0/16"
AGENT_ADDRESS_SPACE         = "13.0.0.0/16"

# Gateway variables
APP_GATEWAY_NAME            = "ApplicationGateway1"
VIRTUAL_NETWORK_NAME        = "aks-vnet"
APPGW_PUBLIC_IP_NAME        = "myappgwpublicip"

# AKS variables
DNS_PREFIX  = "aks-cluster-dns"
USER_LINUX_NODE_POOL_NAME = "userlinux"
USER_LINUX_NODE_POOL_MODE = "User"
ENVIRONMENT = "dev"

# VM variables
AGENT_VM_NAME = "agent-vm-01"
ADMIN_USERNAME = "prime"
ADMIN_PASSWORD = "P@ssw0rdP@ssw0rd"
VM_SIZE = "Standard_DS1_v2"
