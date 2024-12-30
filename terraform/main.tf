terraform {
  backend "azurerm" {
    use_azuread_auth = true
    use_oidc         = true
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.0.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {}

# Configure the Azure Active Directory Provider
provider "azuread" {
  use_oidc  = true
  tenant_id = var.tenant_id
}

provider "azurerm" {
  use_oidc = true
  features {}
}

locals {
  environment_types               = toset(["prd", "sta", "tst", "dev"])
  container_registry_environments = toset(["dev"]) #Should ideally be the same as for environment_types, but I don't want to pay for it atm.

  product_environments = flatten([
    for product in var.Products : [
      for env in product.Environments : {
        product_environment = lower("${product.ProductName}-${env.Name}")
        product_name        = lower(product.ProductName)
        environment_name    = lower(env.Name)
        environment_type    = lower(env.Type)
        location            = lower(env.Location)
        requires_acr_push   = env.ContainerRegistryNeeded
      }
    ]
  ])

  product_capitalization_lookup = {
    for product in var.Products : lower(product.ProductName) => {
      product_name = product.ProductName
    }
  }
}

resource "azurerm_resource_group" "state_file_resource_group" {
  for_each = local.environment_types

  name     = "rg-landingzone-shared-${each.key}-westeurope"
  location = "westeurope"

  tags = {
    "provision" = "landingzones"
  }
}

resource "azurerm_container_registry" "container_registry" {
  for_each = local.container_registry_environments

  name                = "tgclz${each.key}acr"
  resource_group_name = azurerm_resource_group.state_file_resource_group[each.key].name
  location            = azurerm_resource_group.state_file_resource_group[each.key].location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_storage_account" "state_file_storage_account" {
  for_each = local.environment_types

  name = "tgcststate${each.key}"

  location            = azurerm_resource_group.state_file_resource_group[each.key].location
  resource_group_name = azurerm_resource_group.state_file_resource_group[each.key].name

  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    "provision" = "landingzones"
  }
}

resource "azurerm_storage_container" "state_file_storage_account_container" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  storage_account_name = azurerm_storage_account.state_file_storage_account[each.value.environment_name].name

  name = "tfstate-${each.value.product_name}"
}

resource "github_repository" "product_repository" {
  for_each = { for product in var.Products : product.ProductName => product }

  name        = "TGC.${each.value.ProductName}"
  description = "Repository for ${each.value.ProductName}. Auto-generated by Landingzone."
  visibility  = "public"

  template {
    owner                = "aatrisgn"
    repository           = "default_repository"
    include_all_branches = true
  }
}

resource "github_repository_environment" "product_repository_environments" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  environment         = each.value.environment_name
  repository          = "TGC.${each.value.product_name}"
  prevent_self_review = false

  depends_on = [github_repository.product_repository]
}

resource "azurerm_resource_group" "product_environment_group" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  name     = "rg-${each.key}-${each.value.location}"
  location = each.value.location

  tags = {
    "provision" = "landingzones"
  }
}

resource "azuread_application" "product_environment_app_regs" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  display_name = lower("tgc-${each.key}-spn")
}

resource "azuread_application_federated_identity_credential" "spn_federated_identity" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  application_id = azuread_application.product_environment_app_regs[each.key].id

  display_name = each.value.product_environment
  subject      = "repo:aatrisgn/TGC.${each.value.product_name}:environment:${each.value.environment_name}"
  description  = "Auto-generated by landingzone for TGC.${each.value.product_name} GitHub repo."

  audiences = ["api://AzureADTokenExchange"]
  issuer    = "https://token.actions.githubusercontent.com"
}

resource "azuread_service_principal" "product_environment_spns" {
  for_each  = azuread_application.product_environment_app_regs
  client_id = each.value.client_id
}

resource "azurerm_role_assignment" "product_environment_owner" {
  for_each = azuread_service_principal.product_environment_spns

  scope                = azurerm_resource_group.product_environment_group[each.key].id
  role_definition_name = "Owner"
  principal_id         = each.value.object_id
}

resource "github_actions_secret" "secret_subscription_id" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  repository      = "TGC.${each.value.product_name}"
  secret_name     = "${replace(each.key, "-", "_")}_subscriptiond_id"
  plaintext_value = data.azurerm_client_config.azurerm_client_config.subscription_id

  depends_on = [github_repository.product_repository]
}

resource "github_actions_secret" "secret_tenant_id" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  repository      = "TGC.${each.value.product_name}"
  secret_name     = "${replace(each.key, "-", "_")}_tenant_id"
  plaintext_value = data.azurerm_client_config.azurerm_client_config.tenant_id

  depends_on = [github_repository.product_repository]
}

resource "github_actions_secret" "secret_storage_account_name" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  repository      = github_repository.product_repository[local.product_capitalization_lookup[each.value.product_name].product_name].name
  secret_name     = "${replace(each.key, "-", "_")}_tfstate_storage_account_name"
  plaintext_value = azurerm_storage_account.state_file_storage_account[each.value.environment_name].name
}

resource "github_actions_secret" "secret_storage_container_name" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  repository      = github_repository.product_repository[local.product_capitalization_lookup[each.value.product_name].product_name].name
  secret_name     = "${replace(each.key, "-", "_")}_tfstate_storage_container_name"
  plaintext_value = azurerm_storage_container.state_file_storage_account_container[each.value.product_environment].name
}

resource "github_actions_secret" "secret_client_id" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  #Should directly reference repositories
  repository      = "TGC.${each.value.product_name}"
  secret_name     = "${replace(each.key, "-", "_")}_client_id"
  plaintext_value = azuread_application.product_environment_app_regs[each.key].client_id

  depends_on = [github_repository.product_repository]
}

resource "azurerm_role_assignment" "state_storage_account_role_assignment" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  scope                = azurerm_storage_account.state_file_storage_account[each.value.environment_name].id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.product_environment_spns[each.key].object_id
}

resource "azurerm_role_assignment" "state_storage_container_role_assignment" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  scope                = azurerm_storage_container.state_file_storage_account_container[each.key].resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.product_environment_spns[each.key].object_id
}

resource "azurerm_role_assignment" "acr_pull_role_assignment" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment
  }

  scope                = azurerm_container_registry.container_registry[each.value.environment_name].id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.product_environment_spns[each.key].object_id
}

resource "azurerm_role_assignment" "acr_push_role_assignment" {
  for_each = {
    for product_environment in local.product_environments : product_environment.product_environment => product_environment if product_environment.requires_acr_push
  }

  scope                = azurerm_container_registry.container_registry[each.value.environment_name].id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.product_environment_spns[each.key].object_id
}
