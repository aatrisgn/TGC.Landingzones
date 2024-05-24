using '../deployFrontdoor.bicep'

param dnsZones = [
  {
    name: 'hoolixyz'
  }
  {
    name: 'moonshot'
  }
  {
    name: 'FTXTrading'
  }
]

param frontDoorName = 'afd-tgc-prd-main-global'
param rootDNSZoneFQDN = 'tgcportal.com'
