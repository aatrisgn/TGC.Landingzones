data "azuread_domains" "example" {
  only_initial = true
}

data "azurerm_client_config" "azurerm_client_config" {}