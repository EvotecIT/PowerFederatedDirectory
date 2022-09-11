Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Verbose -Suppress

#Add-FederatedDirectoryUser -DirectoryID $DirectoryID -UserName 'test1@evotec.pl' -DisplayName 'test' -Verbose
Add-FederatedDirectoryUser -UserName 'test11111@test.pl' -DisplayName 'T est111' -Verbose #-UserType Employee
Add-FederatedDirectoryUser -UserName 'TestUser1@test.pl' -DisplayName 'TestUser' -Verbose