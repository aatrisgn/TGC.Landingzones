resource "azurerm_resource_group" "state_file_resource_group" {
  provider = azurerm_new
  name     = "rg-logging-shared-${var.environment}-westeurope"
  location = "westeurope"

  tags = {
    "provision" = "landingzones"
  }

  //Added during migration phase
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_log_analytics_workspace" "shared_log_analytic_workspace" {
  provider            = azurerm_new
  name                = "law-logging-shared-${var.environment}-westeurope"
  resource_group_name = azurerm_resource_group.state_file_resource_group.name
  location            = azurerm_resource_group.state_file_resource_group.location

  retention_in_days = 30 //Just keeping it the lowest to minimize cost

  tags = {
    "provision" = "landingzones"
  }

  //Added during migration phase
  lifecycle {
    prevent_destroy = true
  }
}
