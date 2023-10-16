[CmdletBinding()]
param(
     [Parameter()]
     [string]$repositoryName,
     [Parameter()]
     [string]$authToken
)

$rootUrl = "https://api.github.com"

$headers = @{
    Accept = 'application/vnd.github.v3+json';
    Authorization = "token $authToken";
    'Content-Type' = 'application/json';
} 

function CreateRepository(){    
    $repositoryPayload = @{
        name="TGC.$repositoryName"
        private=$false
    } | ConvertTo-Json
    
    $createRepositoryUrl = "$rootUrl/user/repos" # This should be updated to /orgs/{org}/repos for orgs
    
    Invoke-WebRequest -Uri $createRepositoryUrl -Method POST -Body $repositoryPayload -Headers $headers
}

$getRepositoryUrl = "$rootUrl/repos/aatrisgn/$repositoryName" #Update in other cases

try{
    $Response = Invoke-WebRequest -Uri $getRepositoryUrl -Method GET -Headers $headers
    $StatusCode = $Response.StatusCode
    Write-Host "Repository '$repositoryName' already exists. Skipping."
} catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
    if($StatusCode -eq 404){
        Write-Host "No existing repository exists for $repositoryName"
        CreateRepository
    } else {
        throw
    }
}