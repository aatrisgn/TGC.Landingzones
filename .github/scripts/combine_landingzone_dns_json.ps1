# Define the root folder to search
param (
    [string]$rootFolder,
    [string]$outputFilePath
)

# Get all landingZone.json files recursively 
Write-Host "Locating landingzones.json files in $rootFolder ..."

$jsonFiles = Get-ChildItem -Path $rootFolder -Filter "landingZone.json" -Recurse 

Write-Host $jsonFiles

# Initialize an array to hold the combined payload 
$combinedNameServers = @() # Loop through each JSON file and add its content to the combined payload 

foreach ($file in $jsonFiles) {
    # Read and parse the JSON content
    $jsonContent = Get-Content -Path $file.FullName | ConvertFrom-Json

    # Loop through environments and collect ChildzoneNS.NameServers
    foreach ($env in $jsonContent.Environments) {
        if ($env.ChildzoneNS) {
            $combinedNameServers += $env.ChildzoneNS.NameServers
        }
    }
}

# Convert the combined payload to JSON format 
$combinedJson = $combinedNameServers | ConvertTo-Json -Depth 5 

Write-host "Located the following json:"
Write-Host $combinedJson

$outputFilePath = "$outputFilePath/dnszone_input.auto.tfvars.json"

# Write the combined JSON to the output file 
$combinedJson | Set-Content -Path $outputFilePath