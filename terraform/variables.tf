variable "Products" {
    description = "List of products"
    type = list(
        object({
            ProductName = string
            Environments = list(object(
            {
                Name = string
                Type = string
                Location = string
            }))
        })
    )
}

# variable "ProductName" {
#   description = "Product name"
#   type        = string
# }

# variable "Environments" {
#   description = "List of environments"
#   type = list(object(
#     {
#       Name = string
#       Type = string
#   }))
# }