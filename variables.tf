variable "aiservices" {
  description = "Contains the cognitive services account configuration"
  type = object({
    name                               = string
    resource_group                     = optional(string, null)
    location                           = optional(string, null)
    tags                               = optional(map(string))
    sku_name                           = optional(string, "S0")
    custom_subdomain_name              = optional(string)
    fqdns                              = optional(list(string))
    outbound_network_access_restricted = optional(bool, false)
    local_authentication_enabled       = optional(bool, true)
    public_network_access              = optional(string, "Enabled")

    customer_managed_key = optional(object({
      key_vault_key_id   = optional(string)
      managed_hsm_key_id = optional(string)
      identity_client_id = optional(string)
    }))

    identity = optional(object({
      type         = optional(string)
      identity_ids = optional(list(string))
    }))

    storage = optional(object({
      storage_account_id = optional(string)
      identity_client_id = optional(string)
    }))

    network_acls = optional(object({
      default_action = optional(string)
      bypass         = optional(string)
      ip_rules       = optional(list(string))
      virtual_network_rules = optional(object({
        subnet_id                            = string
        ignore_missing_vnet_service_endpoint = optional(bool)
      }))
    }))
  })

  validation {
    condition     = var.aiservices.location != null || var.location != null
    error_message = "location must be provided either in the AI services object or as a separate variable."
  }

  validation {
    condition     = var.aiservices.resource_group != null || var.resource_group != null
    error_message = "resource group name must be provided either in the AI services object or as a separate variable."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = null
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
