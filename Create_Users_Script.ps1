# ----- Edit these Variables for your own Use Case ----- #
$PASSWORD_FOR_USERS   = "Password1"
$USER_FIRST_LAST_LIST = Get-Content "C:\Users\Administrator\Desktop\Creating_Users_AD\names.txt"
# ------------------------------------------------------ #

$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

# Create Organizational Unit if it doesn't exist
$OU = "OU=_USERS,DC=mydomain,DC=com"
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '_USERS'")) {
    New-ADOrganizationalUnit -Name "_USERS" -Path "DC=mydomain,DC=com" -ProtectedFromAccidentalDeletion $false
}

foreach ($name in $USER_FIRST_LAST_LIST) {
    $first = ($name -split " ")[0].ToLower()
    $last  = ($name -split " ")[1].ToLower()
    $username = "$($first.Substring(0,1))$($last)".ToLower()
    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan
    
    $NewUserSPlat = @{
        SamAccountName = $username
        UserPrincipalName = "$username@mydomain.com"
        AccountPassword = $password
        GivenName = $first
        Surname = $last
        DisplayName = $username
        Name = $username
        EmployeeID = $username
        PasswordNeverExpires = $true
        Path = $OU
        Enabled = $true
    }
    New-AdUser @NewUserSPlat
}

#First: Import-Module ServerManager
#Second: Add-WindowsFeature RSAT-AD-PowerShell
#Third: Import-Module ActiveDirectory
#Fourth: Set-ExecutionPolicy Unrestricted
#Five: Enable-PSRemoting -Force