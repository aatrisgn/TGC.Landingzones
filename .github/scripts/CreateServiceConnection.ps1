[CmdletBinding()]
param(
     [Parameter()]
     [string]$projectName,
     [Parameter()]
     [string]$authToken
)

# $newServiceConnection = (az ad sp create-for-rbac --name $serviceConnectionName --role owner --scopes /subscriptions/$subscriptionId --sdk-auth)

Write-Host "Create Service Connection"
Write-Host "Run GitHub encryptor with service connection info"