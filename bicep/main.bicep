param frontDoorName string

// param routingConfiguration object
resource myFrontDoorResource 'Microsoft.Network/frontDoors@2021-06-01' =  {
  name: frontDoorName
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}
