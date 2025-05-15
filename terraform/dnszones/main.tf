terraform {
  backend "azurerm" {
    use_azuread_auth = true
    use_oidc         = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.0.0"
    }
  }
}

provider "azurerm" {
  use_oidc = true
  features {}
}

# Define child zones corresponding to each parent
variable "child_zones" {
  type    = list(string)
  default = ["child1.example1.com", "child2.example2.com"]
}

resource "azurerm_resource_group" "state_file_resource_group" {

  name     = "rg-dnszones-shared-${var.environment}-westeurope"
  location = "westeurope"

  tags = {
    "provision" = "landingzones"
  }
}

# Create DNS Zones
resource "azurerm_dns_zone" "parent" {
  for_each            = toset(var.root_domains)
  name                = each.value
  resource_group_name = azurerm_resource_group.state_file_resource_group.name
}

# Create Child DNS Zones
resource "azurerm_dns_zone" "childzone" {
  for_each            = local.child_dnszones
  name                = each.value
  resource_group_name = azurerm_resource_group.state_file_resource_group.name
}

# Create NS Records in Parent Zones pointing to Child Zones
resource "azurerm_dns_ns_record" "child_ns" {
  for_each            = azurerm_dns_zone.childzone
  name                = each.key                # Use the child zone name
  zone_name           = split(".", each.key)[1] # Extract parent zone name
  resource_group_name = azurerm_resource_group.state_file_resource_group.name
  records             = azurerm_dns_zone.childzone[each.key].name_servers
  ttl                 = 300
}