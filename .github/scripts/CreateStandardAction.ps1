[CmdletBinding()]
param(
     [Parameter()]
     [string]$serviceConnectionName,
     [Parameter()]
     [string]$subscriptionName
)

$headers = @{
    Accept = 'application/vnd.github.v3+json';
    Authorization = "token $authToken";
    'Content-Type' = 'application/json';
}

$postParams = @{
    name='$repositoryName';
    private=$false;
    visibility="public"
}

$url = "https://api.github.com/user/repos" # This should be updated to /orgs/{org}/repos for orgs

Invoke-WebRequest -Uri $url -Method POST -Body $postParams -Headers $headers -UseBasicParsing