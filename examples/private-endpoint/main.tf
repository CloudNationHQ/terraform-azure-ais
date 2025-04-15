module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 8.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    address_space  = ["10.19.0.0/16"]

    subnets = {
      sn1 = {
        network_security_group = {}
        address_prefixes       = ["10.19.1.0/24"]
      }
    }
  }
}


module "private_dns" {
  source  = "cloudnationhq/pdns/azure"
  version = "~> 3.0"

  resource_group = module.rg.groups.demo.name

  zones = {
    private = {
      cognitive = {
        name = "privatelink.cognitiveservices.azure.com"
        virtual_network_links = {
          link1 = {
            virtual_network_id = module.network.vnet.id
          }
        }
      }
      open-ai = {
        name = "privatelink.openai.azure.com"
        virtual_network_links = {
          link1 = {
            virtual_network_id = module.network.vnet.id
          }
        }
      }
      services-ai = {
        name = "privatelink.services.ai.azure.com"
        virtual_network_links = {
          link1 = {
            virtual_network_id = module.network.vnet.id
          }
        }
      }
    }
  }
}

module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 1.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  endpoints = {
    account = {
      name                           = module.naming.private_endpoint.name
      subnet_id                      = module.network.subnets.sn1.id
      private_connection_resource_id = module.ais.account.id
      private_dns_zone_ids           = [module.private_dns.private_zones.cognitive.id, module.private_dns.private_zones.services-ai.id, module.private_dns.private_zones.open-ai.id]
      subresource_names              = ["account"]
    }
  }
}


module "ais" {
  source  = "cloudnationhq/ais/azure"
  version = "~> 1.0"

  account = {
    name                  = module.naming.cognitive_account.name_unique
    resource_group        = module.rg.groups.demo.name
    location              = module.rg.groups.demo.location
    sku_name              = "S0"
    custom_subdomain_name = "ai-demo"
  }
}
