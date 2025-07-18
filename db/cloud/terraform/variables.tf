variable "AZURE_SUBSCRIPTION_ID" { type = string }
variable "AZURE_CLIENT_ID" { type = string }
variable "AZURE_CLIENT_SECRET" { type = string }
variable "AZURE_TENANT_ID" { type = string }

variable "LOCATION" { type = string }
variable "RESOURCE_GROUP_NAME" { type = string }

variable "STORAGE_ACCOUNT_NAME" { type = string }
variable "STORAGE_ACCOUNT_TIER" { type = string }
variable "STORAGE_ACCOUNT_REPLICATION_TYPE" { type = string }
variable "STORAGE_ACCOUNT_CONTAINER_NAME" { type = string }
variable "STORAGE_ACCOUNT_CONTAINER_ACCESS_TYPE" { type = string }
variable "KEY_VAULT_NAME" { type = string }  

variable "SERVICE_PRINCICAL_NAME" {}
variable "SPN_OBJECT_ID" { type = string }

variable "VNET_NAME" { type = string }

variable "AKS_SUBNET_NAME" { type = string }
variable "APPGW_SUBNET_NAME" { type = string }
variable "ARC_SUBNET_NAME" { type = string }
variable "AGENT_SUBNET_NAME" { type = string }

variable "ARC_NAME" { type = string }
variable "ARC_ADDRESS_SPACE" { type = string }
variable "ARC_SUBNET_ADDRESS_PREFIX" { type = string }
variable "ARC_SKU" { type = string }

variable "DNS_ZONE_SCOPE" { type = string }

variable "AKS_NAME" { type = string }
variable "AKS_DNS_PREFIX" { type = string }
variable "AKS_ADDRESS_SPACE" { type = string }
variable "AKS_SUBNET_ADDRESS_PREFIX" { type = string }
variable "AKS_KUBERNETES_VERSION" { type = string }
variable "AKS_SKU_TIER" { type = string }
variable "AKS_ADMIN_USER" { type = string }
variable "AKS_NETWORK_DNS_SERVICE_IP" { type = string }
variable "AKS_NETWORK_PLUGIN" { type = string }
variable "AKS_NETWORK_SERVICE_CIDR" { type = string }
variable "AKS_ENVIRONMENT" { type = string }

variable "AGENT_VM_NAME" { type = string }
variable "AGENT_VM_NAME_PREFIX" { type = string }
variable "AGENT_VM_SIZE" { type = string }
variable "AGENT_ADDRESS_SPACE" { type = string }
variable "AGENT_SUBNET_ADDRESS_PREFIX" { type = string }
variable "ADMIN_USERNAME" { type = string } 
variable "ADMIN_PASSWORD" { type = string }

variable "APPGW_NAME" { type = string }
variable "APPGW_SUBNET_ADDRESS_PREFIX" { type = string }
variable "APPGW_PUBLIC_IP_NAME" {type = string}


variable "USER_LINUX_NODE_POOL_NAME" {type = string}
variable "USER_LINUX_NODE_POOL_MODE" {type = string}
variable "DNS_PREFIX" { type = string }
variable "AZDO_TOKEN" { type = string }
