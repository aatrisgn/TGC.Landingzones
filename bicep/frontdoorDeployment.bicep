import {ApplicationDomain} from 'types.bicep'

@description('Name of the root DNS zone to be used for provisioning domains and child zones.')
param rootDNSZoneFQDN string

@description('The environment for which the Front Door profile is being created. This is used to determine the name of the profile.')
@allowed([
  'DEV'
  'TST'
  'STA'
  'PRD'
])
param environment string

@description('The name of the Front Door profile to create. Default is "afd-tgc-[environment]-main-global".')
param frontDoorProfileName string = 'afd-tgc-${toLower(environment)}-main-global'

@description('The name of the SKU to use when creating the Front Door profile.')
@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
param frontDoorSkuName string = 'Standard_AzureFrontDoor'

param applicationDNSZones string[]
param applicationDomains ApplicationDomain[]

var isPRD = (toLower(environment) == 'prd') ? true : false

//Fetched the root DNS Zone which is assumed to exist.
resource rootDnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' existing = {
  name: rootDNSZoneFQDN
}

//Creates a DNS Zone for each application domain name in the array
resource prdCreatedDnsZones 'Microsoft.Network/dnsZones@2023-07-01-preview' = [for dnsZone in applicationDNSZones : {
  name: '${dnsZone}.${rootDNSZoneFQDN}'
  location: 'Global'
  properties: {
    zoneType: 'Public'
  }
}]

//Registers NS records for each child DNS zone on parent DNS Zone
resource prdChildNS 'Microsoft.Network/dnsZones/NS@2023-07-01-preview' = [for i in range(0, length(applicationDNSZones)) : {
  dependsOn: prdCreatedDnsZones
  name: applicationDNSZones[i]
  parent: rootDnsZone
  properties: {
    NSRecords: [for some in range(0,4) : {
      nsdname: prdCreatedDnsZones[i].properties.nameServers[some]
      }
    ]
    TTL: 3600
  }
}]

//Creates a DNS Zone for each application domain name in the array
resource subDnsZones 'Microsoft.Network/dnsZones@2023-07-01-preview' =  [for dnsZone in applicationDNSZones : if(isPRD == false) {
  name: '${toLower(environment)}.${dnsZone}.${rootDNSZoneFQDN}'
  location: 'Global'
  properties: {
    zoneType: 'Public'
  }
}]

resource subChildNS 'Microsoft.Network/dnsZones/NS@2023-07-01-preview' = [for i in range(0, length(applicationDNSZones)) : if(isPRD == false) {
  dependsOn: prdCreatedDnsZones
  name: toLower(environment)
  parent: prdCreatedDnsZones[i]
  properties: {
    NSRecords: [for some in range(0,4) : {
      nsdname: subDnsZones[i].properties.nameServers[some]
      }
    ]
    TTL: 3600
  }
}]

resource frontDoorProfile 'Microsoft.Cdn/profiles@2024-02-01' = {
  name: frontDoorProfileName
  location: 'global'
  sku: {
    name: frontDoorSkuName
  }
}

resource frontDoorEndpoints 'Microsoft.Cdn/profiles/afdEndpoints@2024-02-01' = [for dnsZone in applicationDNSZones : {
  name: '${dnsZone}-${environment}'
  parent: frontDoorProfile
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}]

resource frontDoorRoutes 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = [for applicationDomain in applicationDomains : {
  name: applicationDomain.DomainName
  parent: frontDoorEndpoints[indexOf(applicationDNSZones, applicationDomain.DNSZone)]
  dependsOn: [
    frontDoorOrigin // This explicit dependency is required to ensure that the origin group is not empty when the route is created.
    myCustomDomains
  ]
  properties: {

    customDomains: [
      {
        id: myCustomDomains[indexOf(applicationDomains, applicationDomain)].id
      }
    ]
    originGroup: {
      id: frontDoorOriginGroups[indexOf(applicationDomains, applicationDomain)].id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Disabled'
    httpsRedirect: 'Enabled'
  }
}]

resource frontDoorOriginGroups 'Microsoft.Cdn/profiles/originGroups@2024-02-01' = [for applicationDomain in applicationDomains : {
  name: 'org-${applicationDomain.DomainName}-${applicationDomain.DNSZone}'
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'GET'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
  }
}]

resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2024-02-01' = [for applicationDomain in applicationDomains : {
  name: 'or-${applicationDomain.DomainName}-${applicationDomain.DNSZone}'
  parent: frontDoorOriginGroups[indexOf(applicationDomains, applicationDomain)]
  properties: {
    hostName: applicationDomain.Hostname
    httpPort: 80
    httpsPort: 443
    originHostHeader: applicationDomain.Hostname
    priority: 1
    weight: 1000
  }
}]

resource myCustomDomains 'Microsoft.Cdn/profiles/customDomains@2024-02-01' = [for applicationDomain in applicationDomains : {
  parent: frontDoorProfile
  name: isPRD ? '${applicationDomain.DomainName}-${applicationDomain.DNSZone}-${replace(rootDNSZoneFQDN, '.', '-')}' : '${applicationDomain.DomainName}-${toLower(environment)}-${applicationDomain.DNSZone}-${replace(rootDNSZoneFQDN, '.', '-')}'
  properties: {
    azureDnsZone: {
      id: rootDnsZone.id
    }
    hostName: isPRD ? '${applicationDomain.DomainName}.${applicationDomain.DNSZone}.${rootDNSZoneFQDN}' : '${applicationDomain.DomainName}.${toLower(environment)}.${applicationDomain.DNSZone}.${rootDNSZoneFQDN}'
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
  }
}]

resource prdTxtRecords 'Microsoft.Network/dnsZones/TXT@2023-07-01-preview' = [for applicationDomain in applicationDomains : if(isPRD) {
  name: '_dnsauth.${applicationDomain.DomainName}'
  parent: prdCreatedDnsZones[indexOf(applicationDNSZones, applicationDomain.DNSZone)]
  properties: {
    TTL: 3600
    TXTRecords: [
      {
        value: [
          myCustomDomains[indexOf(applicationDomains, applicationDomain)].properties.validationProperties.validationToken
        ]
      }
    ]
  }
}]

resource nonPrdtxtRecords 'Microsoft.Network/dnsZones/TXT@2023-07-01-preview' = [for applicationDomain in applicationDomains : if(isPRD == false) {
  name: '_dnsauth.${applicationDomain.DomainName}'
  parent: subDnsZones[indexOf(applicationDNSZones, applicationDomain.DNSZone)]
  properties: {
    TTL: 3600
    TXTRecords: [
      {
        value: [
          myCustomDomains[indexOf(applicationDomains, applicationDomain)].properties.validationProperties.validationToken
        ]
      }
    ]
  }
}]

resource cnamesNonPrd 'Microsoft.Network/dnsZones/CNAME@2023-07-01-preview' = [for applicationDomain in applicationDomains : if(isPRD) {
  name: applicationDomain.DomainName
  parent: prdCreatedDnsZones[indexOf(applicationDNSZones, applicationDomain.DNSZone)]
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: frontDoorEndpoints[indexOf(applicationDNSZones, applicationDomain.DNSZone)].properties.hostName
    }
  }
}]

resource cnamesPrd 'Microsoft.Network/dnsZones/CNAME@2023-07-01-preview' = [for applicationDomain in applicationDomains : if(isPRD == false) {
  name: '${applicationDomain.DomainName}.${toLower(environment)}'
  parent: subDnsZones[indexOf(applicationDNSZones, applicationDomain.DNSZone)]
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: frontDoorEndpoints[indexOf(applicationDNSZones, applicationDomain.DNSZone)].properties.hostName
    }
  }
}]
