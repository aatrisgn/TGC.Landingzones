variable "Products" {
  description = "List of products"
  type = list(
    object({
      ProductName = string
      Environments = list(object(
        {
          Name                           = string
          Type                           = string
          Location                       = string
          ContainerRegistryNeeded        = optional(bool, false)
          ApplicationDeveloperRoleNeeded = optional(bool, false)
      }))
    })
  )
}

variable "tenant_id" {
  description = "ID of the Entra tenant for service prinipal storage"
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.tenant_id))
    error_message = "The variable value must be a valid GUID in the format 00000000-0000-0000-0000-000000000000."
  }
}

variable "shared_log_analytic_workspace" {
  description = "Object refering existing shared log analytic workspace by resource group and name"
  type = object({
    name                = string
    resource_group_name = string
  })
}
