#Requires -RunAsAdministrator

$scriptPath = Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
$rocksaltPath = "C:\Rocksalt"

Write-Host "Script directory: $scriptPath"

# List XML files in the scriptPath (USB)
$xmlFiles = Get-ChildItem -Path $scriptPath -Filter *.xml | Select-Object -ExpandProperty FullName

if (-not $xmlFiles) {
  Write-Host "No XML files found in $scriptPath"
  exit 1
}

if ($xmlFiles.Count -eq 1) {
  $sourceUnattend = $xmlFiles[0]
  Write-Host "Only one unattend XML found: $sourceUnattend"
}
else {
  Write-Host "Available unattend XML files:"
  for ($i = 0; $i -lt $xmlFiles.Count; $i++) {
    Write-Host "$($i+1): $($xmlFiles[$i])"
  }

  # Prompt user to select a file
  do {
    $selection = Read-Host "Enter the number of the unattend file to use"
    $valid = ($selection -as [int]) -and ($selection -ge 1) -and ($selection -le $xmlFiles.Count)
    if (-not $valid) { Write-Host "Invalid selection. Try again." }
  } until ($valid)

  $sourceUnattend = $xmlFiles[$selection - 1]
}

$destUnattend = Join-Path $rocksaltPath "unattend.xml"

# Ensure directory exists
if (-not (Test-Path -Path $rocksaltPath)) {
  New-Item -ItemType Directory -Path $rocksaltPath | Out-Null
  Write-Host "Output directory created: $rocksaltPath"
}
else {
  Write-Host "Output directory already exists: $rocksaltPath"
}

# Copy the unattend file to the output directory
Copy-Item $sourceUnattend -Destination $destUnattend -Force
Write-Host "Copied unattend.xml to $destUnattend"

# Run sysprep with the unattend file
$sysprepExe = "$env:SystemRoot\System32\Sysprep\sysprep.exe"
if (-not (Test-Path $sysprepExe)) {
  Write-Error "Could not find sysprep.exe"
  exit 1
}

Write-Host "Running sysprep..."
Start-Process -FilePath $sysprepExe -ArgumentList "/oobe /shutdown /unattend:`"$destUnattend`"" -Wait

Write-Host "Sysprep complete. System will shut down."