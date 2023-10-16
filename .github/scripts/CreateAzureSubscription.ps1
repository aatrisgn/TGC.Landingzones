[CmdletBinding()]
param(
     [Parameter()]
     [string]$subscriptionName,
     [Parameter()]
     [string]$managementGroupId,
     [Parameter()]
     [string]$billingAccountId,
     [Parameter()]
     [string]$billingProfileId,
     [Parameter()]
     [string]$invoiceSectionId
)

$existingManagementGroup = (az account management-group show --name '$managementGroupId')

if($existingManagementGroup){
    Write-Host "Management group located."
    $existingSubscriptions = (az account management-group subscription show-sub-under-mg --name '$managementGroupId' --query [].displayName)

    if($existingSubscriptions -notcontains $subscriptionName) {
        $accessToken = (az account get-access-token --resource="https://management.azure.com" --query accessToken --output tsv)

        $headers = @{
            Authorization = "bearer $accessToken";
        }

        $postParams = @{
            properties = @{
                billingScope = "/providers/Microsoft.Billing/billingAccounts/$billingAccountId/billingProfiles/$billingProfileId/invoiceSections/$invoiceSectionId"
                DisplayName = $subscriptionName
                Workload = "Production"
            }
        } | ConvertTo-Json

        $url = "https://management.azure.com/providers/Microsoft.Subscription/aliases/sampleAlias?api-version=2021-10-01"

        $newSubscription = Invoke-WebRequest -Uri $url -Method PUT -Body $postParams -Headers $headers -UseBasicParsing | ConvertFrom-Json
        $subscriptionId = $newSubscription.properties.subscriptionId

        $managementGroupAction = "https://management.azure.com/providers/Microsoft.Management/managementGroups/$managementGroupId/subscriptions/$($subscriptionId)?api-version=2020-05-01"
        $updatedManagementGroup = Invoke-WebRequest -Uri $managementGroupAction -Method PUT -Headers $headers -UseBasicParsing | ConvertFrom-Json
    }
}