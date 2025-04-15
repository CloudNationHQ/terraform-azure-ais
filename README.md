# Ai Services

This terraform module enables the efficient creation and management of azure AI Services.

## Features

Flexible deployment of AI services with multi-deployment capabilities.

Network protection through ACLs and customizable network rules.

Support for customer managed keys.

Utilization of terratest for robust validation.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_ai_services.account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_services) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_account"></a> [account](#input\_account)

Description: Contains the cognitive services account configuration

Type:

```hcl
object({
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

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

### <a name="output_account"></a> [account](#output\_account)

Description: Contains all the outputs for AI services
<!-- END_TF_DOCS -->
## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-ais/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-ais" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/ai-services/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/servicebus/)
- [Rest Api Specs](https://learn.microsoft.com/en-us/azure/ai-services/reference/rest-api-resources)
