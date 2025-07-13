# Configure the GitHub Provider
provider "github" {
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  use_oidc  = true
  tenant_id = var.tenant_id
}

provider "azurerm" {
  use_oidc = true
  features {}
}