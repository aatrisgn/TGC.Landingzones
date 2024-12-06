# Define the root folder to search
param (
    [string]$rootFolder,
    [string]$outputFilePath
)

# Get all landingZone.json files recursively 
$jsonFiles = Get-ChildItem -Path $rootFolder -Filter "landingZone.json" -Recurse 

# Initialize an array to hold the combined payload 
$combinedPayload = @() # Loop through each JSON file and add its content to the combined payload 



foreach ($file in $jsonFiles) {
    $jsonContent = Get-Content -Path $file.FullName
    $convertedJson = $jsonContent | ConvertFrom-Json 
    $convertedJson.PSObject.Properties.Remove('$schema')
    $combinedPayload += $convertedJson
}

# Convert the combined payload to JSON format 
$combinedJson = @{
    Products = $combinedPayload 
} | ConvertTo-Json -Depth 5 

Write-host "Located the following json:"
Write-Host $combinedJson

# Write the combined JSON to the output file 
$combinedJson | Set-Content -Path $outputFilePath