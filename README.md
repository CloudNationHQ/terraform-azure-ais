<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (4.26.0)

## Resources

The following resources are used by this module:

- [azurerm_ai_services.aiservices](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_services) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_aiservices"></a> [aiservices](#input\_aiservices)

Description: Contains the cognitive services account configuration

Type:

```hcl
object({
    name                                         = string
    resource_group                               = optional(string, null)
    location                                     = optional(string, null)
    tags                                         = optional(map(string))
    sku_name                                     = optional(string, "S0")
    kind                                         = optional(string, "CognitiveServices")
    custom_subdomain_name                        = optional(string)
    dynamic_throttling_enabled                   = optional(bool, false)
    fqdns                                        = optional(list(string))
    local_auth_enabled                           = optional(bool, false)
    metrics_advisor_aad_client_id                = optional(string)
    metrics_advisor_aad_tenant_id                = optional(string)
    metrics_advisor_super_user_name              = optional(string)
    metrics_advisor_website_name                 = optional(string)
    outbound_network_access_restricted           = optional(bool, false)
    public_network_access_enabled                = optional(bool, false)
    qna_runtime_endpoint                         = optional(string)
    custom_question_answering_search_service_id  = optional(string)
    custom_question_answering_search_service_key = optional(string)

    customer_managed_key = optional(object({
      key_vault_key_id   = string
      identity_client_id = optional(string)
    }))

    identity = optional(object({
      type         = optional(string, "UserAssigned")
      identity_ids = optional(list(string), [])
    }))

    storage = optional(object({
      storage_account_id = optional(string, null)
      identity_client_id = optional(string, null)
    }))

    network_acls = optional(object({
      default_action = optional(string)
      ip_rules       = optional(list(string))
      virtual_network_rules = optional(object({
        subnet_id                            = string
        ignore_missing_vnet_service_endpoint = optional(bool, false)
      }))
    }))

    deployments = optional(map(object({
      name = optional(string)
      model = object({
        format  = string
        name    = string
        version = optional(string)
      })
      sku = object({
        name     = string
        tier     = optional(string)
        size     = optional(string)
        family   = optional(string)
        capacity = optional(number)
      })
    })))

    blocklists = optional(map(object({
      name        = optional(string)
      description = optional(string)
    })))

    policies = optional(map(object({
      name             = optional(string)
      base_policy_name = string
      mode             = optional(string)
      tags             = optional(map(string))
      content_filter = object({
        name               = string
        filter_enabled     = bool
        block_enabled      = bool
        severity_threshold = string
        source             = string
      })
    })))
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: contains naming convention

Type: `map(string)`

Default: `null`

### <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_aiservices"></a> [aiservices](#output\_aiservices)

Description: Contains all the outputs for AI services
<!-- END_TF_DOCS -->