using '../deployFrontdoor.bicep'

param dnsZones = [
  {
    ZoneName: 'hoolixyz'
  }
  {
    ZoneName: 'moonshot'
  }
  {
    ZoneName: 'FTXTrading'
  }
]

param frontDoorName = 'afd-tgc-prd-main-global'
param rootDNSZoneFQDN = 'tgcportal.com'
