variable "base_name" {
  type        = string
  description = "Base name for the storage account"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "account_tier" {
  type        = string
  description = "Storage account tier"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Replication type"
  default     = "LRS"
}

variable "container_name" {
  type        = string
  description = "The name of the storage container"
}

variable "container_access_type" {
  type        = string
  description = "The access level of the container: private, blob, or container"
  default     = "private"
}