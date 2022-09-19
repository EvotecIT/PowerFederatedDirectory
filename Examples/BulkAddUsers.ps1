Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Suppress

$Operations = for ($i = 1; $i -le 100; $i++) {
    Add-FederatedDirectoryUser -Verbose -UserName "TestNewwwww$i@test.pl" -DisplayName "TestUserNew$i" -ManagerDisplayName 'TestUser' -FamilyName 'Kłys' -GivenName 'Przemysłąw' -BulkProcessing
}
$Response = Invoke-FederatedDirectory -Operations $Operations -Verbose #-WhatIf
$Response | Format-Table *
$Response