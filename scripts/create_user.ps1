$Username = Read-Host "Enter Username"
$Password = Read-Host -AsSecureString "Enter Password"

New-LocalUser -Name $Username -Password $Password -FullName $Username -AccountNeverExpires