$rocksaltPath = "C:\Rocksalt"

Write-Host "Installing TeamViewer..."
$teamviewerInstaller = Join-Path -Path $rocksaltPath -ChildPath "TeamViewer_Host_Setup.exe"

# Download TeamViewer
Invoke-WebRequest -Uri "https://customdesignservice.teamviewer.com/download/windows/v15/65v9fp5/TeamViewer_Host_Setup.exe" -OutFile $teamviewerInstaller
if (!$?) {
  Write-Host "Failed to download TeamViewer installer" -ForegroundColor Red
  return $null
}

Write-Host "TeamViewer installer downloaded to $teamviewerInstaller"

# Install TeamViewer silently
Start-Process $teamviewerInstaller -ArgumentList "/S", "/ACCEPTEULA=1" -WindowStyle Hidden -Wait
if (!$?) {
  Write-Host "Failed to install TeamViewer" -ForegroundColor Red
  return $null
}

Write-Host "TeamViewer installed successfully"

# Install all apps in the Installers folder
$exeDirectory = Join-Path -Path $rocksaltPath -ChildPath "Installers"
$exeFiles = Get-ChildItem -Path $exeDirectory -Filter "*.exe"

foreach ($exe in $exeFiles) {
  Write-Host "Installing: $($exe.Name)"
  Start-Process -FilePath $exe.FullName -ArgumentList "/S", "/quiet", "/norestart" -NoNewWindow -Wait
}
