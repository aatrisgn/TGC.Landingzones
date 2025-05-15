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

resource "azurerm_resource_group" "state_file_resource_group" {

  name     = "rg-dnszones-shared-${var.environment}-westeurope"
  location = "westeurope"

  tags = {
    "provision" = "landingzones"
  }
}

resource "azurerm_dns_zone" "root_dns_zone" {
  for_each            = toset(var.root_domains)
  name                = each.value
  resource_group_name = azurerm_resource_group.state_file_resource_group.name

  #We are hosting our domains in Azure and are therefore pointing manually to these DNS Servers for Name Servers in Simply.
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_dns_zone" "childzone" {
  for_each            = toset(local.child_dnszones)
  name                = each.value
  resource_group_name = azurerm_resource_group.state_file_resource_group.name
}

resource "azurerm_dns_ns_record" "child_ns" {
  for_each            = azurerm_dns_zone.childzone
  name                = split(".", each.key)[0]
  zone_name           = "${split(".", each.key)[1]}.${split(".", each.key)[2]}"
  resource_group_name = azurerm_resource_group.state_file_resource_group.name
  records             = azurerm_dns_zone.childzone[each.key].name_servers
  ttl                 = 300
}