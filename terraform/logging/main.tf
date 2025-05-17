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

  name     = "rg-logging-shared-${var.environment}-westeurope"
  location = "westeurope"

  tags = {
    "provision" = "landingzones"
  }
}

resource "azurerm_log_analytics_workspace" "shared_log_analytic_workspace" {
    name = "law-logging-shared-${var.environment}-westeurope"
    resource_group_name = azurerm_resource_group.state_file_resource_group.name
    location = azurerm_resource_group.state_file_resource_group.location
    
    retention_in_days = 30 //Just keeping it the lowest to minimize cost
    
    tags = {
    "provision" = "landingzones"
  }
}
