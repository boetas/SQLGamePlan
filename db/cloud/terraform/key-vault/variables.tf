variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "tenant_id" {}
variable "object_id" {}

variable "enabled_for_disk_encryption" {
  default = true
}

variable "soft_delete_retention_days" {
  default = 7
}

variable "purge_protection_enabled" {
  default = false
}

variable "sku_name" {
  default = "standard"
}

variable "key_permissions" {
  type    = list(string)
  default = ["Get"]
}

variable "secret_permissions" {
  type    = list(string)
  default = ["Get"]
}

variable "storage_permissions" {
  type    = list(string)
  default = ["Get"]
}
