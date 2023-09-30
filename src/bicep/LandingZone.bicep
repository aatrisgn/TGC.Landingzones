param subscriptionName string
param billingAccountName string
param billingProfileName string
param invoiceSectionName string
param managementGroupId string

var billingScope = '/billingAccounts/${billingAccountName}/billingProfiles/${billingProfileName}/invoiceSections/${invoiceSectionName}'

targetScope = 'managementGroup'

module landingZoneSubscription 'br/tgc:bicep/modules/subscription/aliases:v3' = {
  name: subscriptionName
  params:{
    billingScope:billingScope
    subscriptionName: subscriptionName
    managementGroupId: managementGroupId
  }
}
