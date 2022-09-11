Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Suppress

Remove-FederatedDirectoryUser -Id '171a8cd0-2382-11ed-9dd1-b13400d703b6' -Verbose
Get-FederatedDirectoryUser -UserName 'testuser' | Remove-FederatedDirectoryUser -Verbose
Remove-FederatedDirectoryUser -Verbose -UserName 'testuser'