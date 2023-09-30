param subscriptionName string
param billingAccountId string
param billingProfileId string
param invoiceSectionId string
param managementGroupId string

var billingScope = '/billingAccounts/${billingAccountId}/billingProfiles/${billingProfileId}/invoiceSections/${invoiceSectionId}'
var fullManagementGroupId = '/providers/Microsoft.Management/managementGroups/${managementGroupId}'

targetScope = 'tenant'

module landingZoneSubscription 'br/tgc:bicep/modules/subscription/aliases:v4' = {
  name: subscriptionName
  params:{
    billingScope:billingScope
    subscriptionName: subscriptionName
    managementGroupId: fullManagementGroupId
  }
}
