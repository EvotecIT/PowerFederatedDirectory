Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Suppress

$Operations = for ($i = 1; $i -le 10; $i++) {
    Add-FederatedDirectoryUser -UserName "TestUserąęNew$i@test.pl" -DisplayName "TestęąśśśUserNew$i" -ManagerDisplayName 'TestUser' -FamilyName 'Kłys' -GivenName 'Przemysłąw' -BulkProcessing
}
$Response = Invoke-FederatedDirectory -Operations $Operations  #-WhatIf
$Response | Format-Table *