@description('Name of the frontdoor instance')
param frontDoorName string
param dnsZones array
param rootDNSZoneFQDN string
param location string = resourceGroup().location

resource createdDnsZones 'Microsoft.Network/dnsZones@2018-05-01' = [for dnsZone in dnsZones : {
  name: dnsZone.ZoneName
  location: location
  properties: {
    zoneType: 'Public'
  }
}]

resource rootDnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: rootDNSZoneFQDN
}

resource childNS 'Microsoft.Network/dnsZones/NS@2018-05-01' = [for i in range(0, length(dnsZones)) : {
  dependsOn: createdDnsZones
  name: 'string'
  parent: rootDnsZone
  properties: {
    NSRecords: [for some in range(0,4) : {
      nsdname: createdDnsZones[i].properties.nameServers[some]
      }
    ]
    targetResource: {
      id: 'string'
    }
    TTL: 3600
  }
}]



// param routingConfiguration object
resource myFrontDoorResource 'Microsoft.Network/frontDoors@2021-06-01' =  {
  name: frontDoorName
  location: 'global'
  properties: {
    enabledState: 'Enabled'

    frontendEndpoints: [
    //   for frontendEndpoint in customDomains : {
    //     name: '{frontEndEndPoint}1'
    //     properties: {
    //       hostName: '${frontendEndpoint}.azurefd.net'
    //       sessionAffinityEnabledState: 'Disabled'
    //     }
    //   }
    ]

    loadBalancingSettings: [
      {
        name: 'Somethgon'
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
        }
      }
    ]

    healthProbeSettings: [
      {
        name: 'Something12'
        properties: {
          path: '/health'
          protocol: 'Http'
          intervalInSeconds: 120
        }
      }
    ]

    // backendPools: [
    //   for backendPool in backendPools : {
    //     name: backendPool.name
    //     properties: {
    //       backends: [
    //         {
    //           address: backEndAddress
    //           backendHostHeader: backEndAddress
    //           httpPort: 80
    //           httpsPort: 443
    //           weight: 100
    //           priority: 1
    //           enabledState: 'Enabled'
    //         }
    //       ]
    //       loadBalancingSettings: {
    //         id: resourceId('Microsoft.Network/frontDoors/loadBalancingSettings', frontDoorName, loadBalancingSettingsName)
    //       }
    //       healthProbeSettings: {
    //         id: resourceId('Microsoft.Network/frontDoors/healthProbeSettings', frontDoorName, healthProbeSettingsName)
    //       }
    //     }
    //   }
    // ]

    // routingRules: [
    //   {
    //     name: routingRuleName
    //     properties: {
    //       frontendEndpoints: [
    //         {
    //           id: resourceId('Microsoft.Network/frontDoors/frontEndEndpoints', frontDoorName, frontEndEndPointName)
    //         }
    //       ]
    //       acceptedProtocols: [
    //         'Http'
    //         'Https'
    //       ]
    //       patternsToMatch: [
    //         '/*'
    //       ]
    //       routeConfiguration: {
    //         '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
    //         forwardingProtocol: 'MatchRequest'
    //         backendPool: {
    //           id: resourceId('Microsoft.Network/frontDoors/backEndPools', frontDoorName, backEndPoolName)
    //         }
    //       }
    //       enabledState: 'Enabled'
    //     }
    //   }
    // ]
  }
}
