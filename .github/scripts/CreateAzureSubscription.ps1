[CmdletBinding()]
param(
     [Parameter()]
     [string]$subscriptionName
)

$existingSubscriptions = (az account management-group list) | ConvertFrom-Json

if($existingSubscriptions -notcontains $subscriptionName){
    az account management-group subscription add --name Contoso01 --subscription $subscriptionName
}