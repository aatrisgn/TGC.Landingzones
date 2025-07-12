provider "azurerm" {
  use_oidc = true
  features {}
}

provider "azurerm" {
  alias           = "old"
  use_oidc        = true
  subscription_id = var.old_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "new"
  use_oidc        = true
  subscription_id = var.new_subscription_id
  features {}
}
