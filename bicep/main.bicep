param frontDoorName string

resource myFrontDoorResource 'Microsoft.Network/frontDoors@2021-06-01' =  {
  name: frontDoorName
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}
