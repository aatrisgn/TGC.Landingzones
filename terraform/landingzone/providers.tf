# Configure the GitHub Provider
provider "github" {
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  use_oidc  = true
  tenant_id = var.tenant_id
}

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
