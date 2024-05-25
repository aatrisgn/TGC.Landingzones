param (
    [Parameter(Mandatory)]
    [ValidateSet("DEV", "STA", "PRD")]
    [string]$Environment
)

# Construct the base path
$basePath = "Landingzones"

# Get all files matching the pattern

$combinedPayload = [PSCustomObject]@{
    "`$schema" = "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#"
    contentVersion = "1.0.0.0"
    parameters = @{
        environment = @{
            value = $Environment
        }
        rootDNSZoneFQDN = @{
            value = "tgcportal.com"
        }
        applicationDNSZones = @{
            value = @()
        }
        applicationDomains = @{
            value = @()
        }
    }
}

$landingZoneFiles = Get-ChildItem -Path $basePath -File

foreach ($file in $landingZoneFiles) {
    $fileContent = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json

    $combinedPayload.parameters.applicationDNSZones.value += $fileContent.DNS.ApplicationRootDomain

    foreach ($domain in $fileContent.DNS.Domains.$Environment) {
        $combinedPayload.parameters.applicationDomains.value += [PSCustomObject]@{
            DomainName = $domain.Subdomain
            Hostname = $domain.Hostname
            DNSZone = $fileContent.DNS.ApplicationRootDomain
            Environment = $Environment
        }
    }
}

$jsonOutput = $combinedPayload | ConvertTo-Json -Depth 10

write-host "Wrote content to file."

$jsonOutput | Out-File -FilePath "bicep/parameters/applicationDNSZones.parameters.$Environment.json"