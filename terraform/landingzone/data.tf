data "azuread_domains" "example" {
  only_initial = true
}

data "azurerm_client_config" "azurerm_client_config" {}

data "azurerm_log_analytics_workspace" "shared_dev_log_analytic_workspace" {
  name                = var.shared_dev_log_analytic_workspace.name
  resource_group_name = var.shared_dev_log_analytic_workspace.resource_group_name
}

data "azurerm_log_analytics_workspace" "shared_prd_log_analytic_workspace" {
  name                = var.shared_prd_log_analytic_workspace.name
  resource_group_name = var.shared_prd_log_analytic_workspace.resource_group_name
}