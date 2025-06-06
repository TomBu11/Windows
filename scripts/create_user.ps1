$Username = Read-Host "Enter Username"
$Password = Read-Host -AsSecureString "Enter Password"

New-LocalUser -Name $Username -Password $Password -FullName $Username -AccountNeverExpires

Add-LocalGroupMember -Group "Users" -Member $Username
Write-Host "User $Username created and added to Users group."

$addUserToAdmins = Read-Host "Add user to admins? (Y/n)"
if ($addUserToAdmins -ne "n" -and $addUserToAdmins -ne "N") {
    Add-LocalGroupMember -Group "Administrators" -Member $Username
    Write-Host "User $Username added to Administrators group."
} else {
    Write-Host "User $Username created without admin privileges."
}