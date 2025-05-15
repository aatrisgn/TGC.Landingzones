locals {
  child_dnszones = flatten([
    for item1 in var.var.root_domains : [
      for item2 in var.var.childzone_environments : "${item1}.${item2}"
    ]
  ])
}