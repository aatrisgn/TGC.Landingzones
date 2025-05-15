locals {
  child_dnszones = flatten([
    for root_domain in var.root_domains : [
      for childzone in var.childzone_environments : "${childzone}.${root_domain}"
    ]
  ])
}