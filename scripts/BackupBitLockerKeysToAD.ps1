#Requires -RunAsAdministrator

Get-BitLockerVolume | Where-Object {$_.ProtectionStatus -eq "On"} | ForEach-Object {
 $MountPoint = $_.MountPoint
 $_.KeyProtector | Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"} | ForEach-Object {
  Backup-BitLockerKeyProtector -MountPoint $MountPoint -KeyProtectorId $_.KeyProtectorId
 }
}