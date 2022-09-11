Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Verbose -Suppress

Set-FederatedDirectoryUser -Id 'b558c900-3013-11ed-8f66-67bf21b5dbc9' -DisplayName 'New name' -FamilyName 'New namme' -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Verbose -Action Update