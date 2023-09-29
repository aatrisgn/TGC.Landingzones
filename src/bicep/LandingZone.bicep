param subscriptionName string
param billingAccountName string
param billingProfileName string
param invoiceSectionName string
param managementGroupId string

var billingScope = '/billingAccounts/${billingAccountName}/billingProfiles/${billingProfileName}/invoiceSections/${invoiceSectionName}'

module landingZoneSubscription 'br/tgc:bicep/modules/subscription/aliases:v2' = {
  name: subscriptionName
  params:{
    billingScope:billingScope
    subscriptionName: subscriptionName
    managementGroupId: managementGroupId
  }
}
