locals {
  environment_types               = toset(["prd", "sta", "tst", "dev"])

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