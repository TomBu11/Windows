#Requires -RunAsAdministrator

$outPath = "C:\Rocksalt"

Get-BitLockerVolume | Where-Object { $_.ProtectionStatus -eq "On" } | ForEach-Object {
  $MountPoint = $_.MountPoint
  $_.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" } | ForEach-Object {
    Backup-BitLockerKeyProtector -MountPoint $MountPoint -KeyProtectorId $_.KeyProtectorId
  }
}

if (-not (Test-Path -Path $outPath)) {
  New-Item -ItemType Directory -Path $outPath | Out-Null
}

Add-Content -Path "$outPath\Bitlocker_Backup_Log.txt" -Value "$(Get-Date) : $env:USERNAME"
