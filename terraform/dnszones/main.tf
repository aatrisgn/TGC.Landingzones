resource "azurerm_resource_group" "dnszone_resource_group" {

  name     = "rg-dnszones-shared-${var.environment}-global"
  location = "westeurope"

  tags = {
    "provision" = "landingzones"
  }
}

resource "azurerm_dns_zone" "root_dns_zone" {
  for_each = toset(var.root_domains)

  name                = each.value
  resource_group_name = azurerm_resource_group.dnszone_resource_group.name
}

resource "azurerm_dns_zone" "childzone" {
  for_each = toset(local.child_dnszones)

  name                = each.value
  resource_group_name = azurerm_resource_group.dnszone_resource_group.name
}

resource "azurerm_dns_ns_record" "child_ns" {
  for_each = azurerm_dns_zone.childzone

  name                = split(".", each.key)[0]
  zone_name           = "${split(".", each.key)[1]}.${split(".", each.key)[2]}"
  resource_group_name = azurerm_resource_group.dnszone_resource_group.name
  records             = azurerm_dns_zone.childzone[each.key].name_servers
  ttl                 = 300
}
