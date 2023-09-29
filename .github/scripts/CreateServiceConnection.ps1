[CmdletBinding()]
param(
     [Parameter()]
     [string]$serviceConnectionName,
     [Parameter()]
     [string]$repositoryName,
     [Parameter()]
     [string]$subscriptionId
)

$rootUrl = "https://api.github.com"

$headers = @{
    Accept = 'application/vnd.github.v3+json';
    Authorization = "token $authToken";
    'Content-Type' = 'application/json';
}



$secretName = "$($serviceConnectionName)_credentials"

$url = "$rootUrl/repos/aatrisgn/$repositoryName/actions/secrets/$secretName"



$newServiceConnection = (az ad sp create-for-rbac --name $serviceConnectionName --role owner --scopes /subscriptions/$subscriptionId --sdk-auth)


$postParams = @{
    encrypted_value=$newServiceConnection;
}


Invoke-WebRequest -Uri $url -Method PUT -Body $postParams -Headers $headers