[CmdletBinding()]
param(
     [Parameter()]
     [string]$subscriptionName
)

$existingSubscriptions = (az account management-group list) | ConvertFrom-Json

if($existingSubscriptions -notcontains $subscriptionName){
    az account management-group subscription add --name Contoso01 --subscription $subscriptionName
}

Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module -Name Az.Accounts -AllowClobber

$context = Get-AzContext

$resource = Get-AzAccessToken -ResourceUrl "https://management.azure.com" -DefaultProfile $context
# $resource = Get-AzAccessToken -ResourceTypeName ${{ inputs.resource-type-name }} -DefaultProfile $context


# $existingSubscriptions = (az account management-group list) | ConvertFrom-Json

# if($existingSubscriptions -notcontains $subscriptionName){
#     az account management-group subscription add --name Contoso01 --subscription $subscriptionName
# }


#https://learn.microsoft.com/en-us/rest/api/subscription/2018-11-01-preview/subscription-factory/create-subscription?tabs=HTTP

$headers = @{
    Authorization = "bearer $($resource.Token)";
}

$postParams = @{
    billingProfileId='$repositoryName';
    displayName=$false; #Subscription name
    skuId='001';
    managementGroupId=
}

$url = "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$billingAccountName/billingProfiles/$billingProfileName/invoiceSections/$invoiceSectionName/providers/Microsoft.Subscription/createSubscription?api-version=2018-11-01-preview"

Invoke-WebRequest -Uri $url -Method POST -Body $postParams -Headers $headers -UseBasicParsing

POST 