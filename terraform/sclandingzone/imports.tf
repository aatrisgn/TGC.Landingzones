locals {
  old_repos = {
    "akshosting" : "TGC.akshosting",
    "Homelab" : "TGC.Homelab",
    "TerminalKey" : "TGC.TerminalKey",
    "StockGame" : "TGC.StockGame",
    "RegnerDetNu" : "TGC.RegnerDetNu",
    "HomeAutomation" : "TGC.HomeAutomation",
    "SenderMadsWedding" : "TGC.SenderMadsWedding",
    "StreetCroquetDK" : "TGC.StreetCroquetDK",
    "AsgerThyregoddk" : "TGC.AsgerThyregoddk",
    "StarRealming" : "TGC.StarRealming"
  }
}

import {
  for_each = var.environment == "prd" ? {
    for key, value in local.old_repos : key => value
  } : {}

  #local.old_repos if var.environment == "prd"

  to = github_repository.product_repository[each.key]
  id = each.value
}
