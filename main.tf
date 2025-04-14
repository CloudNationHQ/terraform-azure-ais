resource "azurerm_ai_services" "aiservices" {
  resource_group_name = coalesce(
    lookup(
      var.aiservices, "resource_group", null
    ), var.resource_group
  )

  location = coalesce(
    lookup(var.aiservices, "location", null
    ), var.location
  )

  name                               = var.aiservices.name
  sku_name                           = var.aiservices.sku_name
  custom_subdomain_name              = var.aiservices.custom_subdomain_name
  fqdns                              = var.aiservices.fqdns
  local_authentication_enabled       = var.aiservices.local_authentication_enabled
  outbound_network_access_restricted = var.aiservices.outbound_network_access_restricted
  public_network_access              = var.aiservices.public_network_access


  dynamic "customer_managed_key" {
    for_each = try(var.aiservices.customer_managed_key, null) != null ? [var.aiservices.customer_managed_key] : []

    content {
      key_vault_key_id   = customer_managed_key.value.key_vault_key_id
      managed_hsm_key_id = customer_managed_key.value.managed_hsm_key_id
      identity_client_id = customer_managed_key.value.identity_client_id
    }
  }

  dynamic "identity" {
    for_each = try(var.aiservices.identity, null) != null ? { default = var.aiservices.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_acls" {
    for_each = try(var.aiservices.network_acls, null) != null ? { default = var.aiservices.network_acls } : {}

    content {
      # bypass         = network_acls.value.bypass
      default_action = network_acls.value.default_action
      ip_rules       = network_acls.value.ip_rules

      dynamic "virtual_network_rules" {
        for_each = lookup(network_acls.value, "virtual_network_rules", null) != null ? [lookup(network_acls.value, "virtual_network_rules")] : []

        content {
          subnet_id                            = virtual_network_rules.value.subnet_id
          ignore_missing_vnet_service_endpoint = virtual_network_rules.value.ignore_missing_vnet_service_endpoint
        }
      }
    }
  }

  dynamic "storage" {
    for_each = try(var.aiservices.storage, null) != null ? { default = var.aiservices.storage } : {}

    content {
      storage_account_id = storage.value.storage_account_id
      identity_client_id = storage.value.identity_client_id
    }

  }

  tags = try(
    var.aiservices.tags, var.tags
  )
}
