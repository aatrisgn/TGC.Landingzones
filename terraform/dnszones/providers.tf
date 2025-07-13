provider "azurerm_old" {
  use_oidc        = true
  subscription_id = var.old_subscription_id
  features {}
}

provider "azurerm_new" {
  use_oidc        = true
  subscription_id = var.new_subscription_id
  features {}
}
