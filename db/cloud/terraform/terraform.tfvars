# Location and Resource Group
LOCATION                    = "South Africa North"
RESOURCE_GROUP_NAME          = "k8s"

# Storage Account related variables
STORAGE_ACCOUNT_NAME = "k8sstorage22220022"
STORAGE_ACCOUNT_TIER = "Standard"
STORAGE_ACCOUNT_REPLICATION_TYPE = "LRS"
STORAGE_ACCOUNT_CONTAINER_NAME = "tfstates"
STORAGE_ACCOUNT_CONTAINER_ACCESS_TYPE = "private"

# KeyVault Name
KEY_VAULT_NAME = "secret-vault-22022"

# Service Principal Name
SERVICE_PRINCICAL_NAME = "sp-devops-practice"

# Virtual Network related variables
VNET_NAME                   = "k8s-vnet"

# Application Gateway (AppGW) related variables
APPGW_NAME                  = "ApplicationGateway1"
APPGW_PUBLIC_IP_NAME        = "myappgwpublicip"
APPGW_SUBNET_NAME           = "appgw-subnet"
APPGW_SUBNET_ADDRESS_PREFIX = "11.2.0.0/24"

# Azure Container Registry (ACR) related variables
# ACR variables
ARC_NAME                    = "k8sacr22022"
ARC_SKU                     = "Premium"
ARC_SUBNET_NAME             = "acr-subnet"
ARC_SUBNET_ADDRESS_PREFIX   = "11.0.1.0/24"
ARC_ADDRESS_SPACE           = "11.0.0.0/16"

# Agent related variables (for VMs or other agents)
AGENT_SUBNET_NAME           = "agent-subnet"
AGENT_SUBNET_ADDRESS_PREFIX = "11.3.0.0/24"
AGENT_ADDRESS_SPACE         = "11.3.0.0/16"
AGENT_VM_NAME               = "agent-vm-01"
AGENT_VM_NAME_PREFIX        = "agent"
AGENT_VM_SIZE               = "Standard_DS1_v2"
ADMIN_USERNAME              = "prime"
ADMIN_PASSWORD              = "P@ssw0rdP@ssw0rd"

# DNS
DNS_ZONE_SCOPE              = "private.southafricanorth.azmk8s.io"
DNS_PREFIX                  = "aks-cluster-dns"

# AKS (Azure Kubernetes Service) related variables
AKS_NAME                    = "myaks"
AKS_DNS_PREFIX              = "myaksdns"
AKS_NETWORK_DNS_SERVICE_IP  = "10.0.0.10"
AKS_NETWORK_SERVICE_CIDR    = "10.0.0.0/16"
AKS_ADDRESS_SPACE           = "10.240.0.0/16"
AKS_SUBNET_NAME             = "aks-subnet"
AKS_SUBNET_ADDRESS_PREFIX   = "10.240.1.0/24"
AKS_KUBERNETES_VERSION      = "1.33.0"
AKS_SKU_TIER                = "Free"
AKS_ADMIN_USER              = "azureuser"
AKS_NETWORK_PLUGIN          = "azure"
USER_LINUX_NODE_POOL_NAME   = "userlinux"
USER_LINUX_NODE_POOL_MODE   = "User"
AKS_ENVIRONMENT             = "dev"
