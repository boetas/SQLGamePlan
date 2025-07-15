variable "AZURE_SUBSCRIPTION_ID" { type = string }
variable "AZURE_CLIENT_ID" { type = string }
variable "AZURE_CLIENT_SECRET" { type = string }
variable "AZURE_TENANT_ID" { type = string }

variable "AKS_VNET_NAME" { type = string }
variable "AKS_ADDRESS_SPACE" { type = string }
variable "AKS_SUBNET_NAME" { type = string }
variable "AKS_SUBNET_ADDRESS_PREFIX" { type = string }
variable "APPGW_SUBNET_NAME" { type = string }
variable "APPGW_SUBNET_ADDRESS_PREFIX" { type = string }

variable "LOCATION" { type = string }
variable "RESOURCE_GROUP_NAME" { type = string }

variable "ACR_VNET_NAME" { type = string }
variable "ACR_SUBNET_NAME" { type = string }
variable "ACR_SUBNET_ADDRESS_PREFIX" { type = string }
variable "ACR_ADDRESS_SPACE" { type = string }

variable "AGENT_VNET_NAME" { type = string }
variable "AGENT_SUBNET_NAME" { type = string }
variable "AGENT_SUBNET_ADDRESS_PREFIX" { type = string }
variable "AGENT_ADDRESS_SPACE" { type = string }

variable "ACR_SKU" { type = string }
variable "ACR_NAME" { type = string }

variable "APP_GATEWAY_NAME" {type = string}
variable "VIRTUAL_NETWORK_NAME" {type = string}

variable "APPGW_PUBLIC_IP_NAME" {type = string}

variable "USER_LINUX_NODE_POOL_NAME" {type = string}
variable "USER_LINUX_NODE_POOL_MODE" {type = string}
variable "ENVIRONMENT" {type = string}
variable "DNS_PREFIX" { type = string }

variable "AGENT_VM_NAME" { type = string }
variable "ADMIN_USERNAME" { type = string } 
variable "ADMIN_PASSWORD" { type = string }
variable "VM_SIZE" { type = string }
