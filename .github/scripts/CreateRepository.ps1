[CmdletBinding()]
param(
     [Parameter()]
     [string]$repositoryName,
     [Parameter()]
     [string]$authToken
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

$url = "https://api.github.com/orgs/aatrisgn/repos"

Invoke-WebRequest -Uri $url -Method POST -Body $postParams -Headers $headers -UseBasicParsing