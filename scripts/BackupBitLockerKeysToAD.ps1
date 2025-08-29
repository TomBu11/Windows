#Requires -RunAsAdministrator

Get-BitLockerVolume | Where-Object { $_.ProtectionStatus -eq "On" } | ForEach-Object {
  $MountPoint = $_.MountPoint
  $_.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" } | ForEach-Object {
    Backup-BitLockerKeyProtector -MountPoint $MountPoint -KeyProtectorId $_.KeyProtectorId
  }
}

Add-Content -Path "C:\Rocksalt\Bitlocker_Backup_Log.txt" -Value "$(Get-Date) : $env:USERNAME"