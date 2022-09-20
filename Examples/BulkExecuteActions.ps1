Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Suppress

$Operations = for ($i = 1; $i -le 1; $i++) {
    Add-FederatedDirectoryUser -UserName "TestNewwwww$i@test.pl" -DisplayName "TestUserNew$i" -ManagerDisplayName 'TestUser' -FamilyName 'Kłys' -GivenName 'Przemysłąw' -BulkProcessing
    #Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -FamilyName 'New namme' -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -Action Update -BulkProcessing
    Set-FederatedDirectoryUser -Id '0c50c6f0-3428-11ed-98e2-11027423d1f1' -DisplayName 'New name' -GivenName "Test" -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -UserName 'TestMe@verymuch.pl' -Action Overwrite -StreetAddress "Test me" -BulkProcessing
    Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -GivenName "Test" -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -UserName 'TestMe@verymuch.pl' -Action Overwrite -StreetAddress "Test me" -BulkProcessing
}
$Response = Invoke-FederatedDirectory -Operations $Operations -ReturnHashtable
$Response | Format-Table

$Response1 = Invoke-FederatedDirectory -Operations $Operations
$Response1 | Format-Table *

$Response2 = Invoke-FederatedDirectory -Operations $Operations -ReturnNative
$Response2 | Format-Table *