resource "azurerm_ai_services" "account" {
  resource_group_name = coalesce(
    lookup(
      var.account, "resource_group", null
    ), var.resource_group
  )

  location = coalesce(
    lookup(var.account, "location", null
    ), var.location
  )

  name                               = var.account.name
  sku_name                           = var.account.sku_name
  custom_subdomain_name              = var.account.custom_subdomain_name
  fqdns                              = var.account.fqdns
  local_authentication_enabled       = var.account.local_authentication_enabled
  outbound_network_access_restricted = var.account.outbound_network_access_restricted
  public_network_access              = var.account.public_network_access


  dynamic "customer_managed_key" {
    for_each = try(var.account.customer_managed_key, null) != null ? [var.account.customer_managed_key] : []

    content {
      key_vault_key_id   = customer_managed_key.value.key_vault_key_id
      managed_hsm_key_id = customer_managed_key.value.managed_hsm_key_id
      identity_client_id = customer_managed_key.value.identity_client_id
    }
  }

  dynamic "identity" {
    for_each = try(var.account.identity, null) != null ? { default = var.account.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_acls" {
    for_each = try(var.account.network_acls, null) != null ? { default = var.account.network_acls } : {}

    content {
      bypass         = network_acls.value.bypass
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
    for_each = try(var.account.storage, null) != null ? { default = var.account.storage } : {}

    content {
      storage_account_id = storage.value.storage_account_id
      identity_client_id = storage.value.identity_client_id
    }
  }

  tags = try(
    var.account.tags, var.tags
  )
}
