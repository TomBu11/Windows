#Requires -RunAsAdministrator

$scriptPath = Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
$rocksaltPath = "C:\Rocksalt"
$sourceUnattend = Join-Path -Path $scriptPath "unattend.xml"
$destUnattend = Join-Path $rocksaltPath "unattend.xml"

# Ensure directory exists
if (-not (Test-Path -Path $rocksaltPath)) {
  New-Item -ItemType Directory -Path $rocksaltPath | Out-Null
  Write-Host "Output directory created: $rocksaltPath"
}
else {
  Write-Host "Output directory already exists: $rocksaltPath"
}

if (-not (Test-Path -Path $sourceUnattend)) {
  Write-Host "Unattend file not found at $sourceUnattend"
  exit 1
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
