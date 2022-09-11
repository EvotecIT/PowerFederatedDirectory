Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Verbose -Suppress

Set-FederatedDirectoryUser -Id '11105df0-31cf-11ed-ada4-2bbc677ce86d' -DisplayName 'New name' -FamilyName 'New namme' -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Verbose -Custom01 'test123' -Action Update