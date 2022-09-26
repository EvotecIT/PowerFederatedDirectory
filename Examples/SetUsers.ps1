﻿Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Suppress

#Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -FamilyName 'New namme' -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Verbose -Custom01 'test123' -Action Update

$Users = Get-FederatedDirectoryUser
foreach ($U in $Users) {
    Set-FederatedDirectoryUser -Id $U.id -ManagerUserName 'BringFood@test.pl' -Verbose
}
Set-FederatedDirectoryUser -SearchUserName 'BringFood@test.pl' -Verbose -Custom01 'test123'