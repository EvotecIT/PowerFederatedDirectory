Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token #-Suppress

#Add-FederatedDirectoryUser -DirectoryID $DirectoryID -UserName 'test1@evotec.pl' -DisplayName 'test' -Verbose
#Add-FederatedDirectoryUser -UserName 'test11111@test.pl' -DisplayName 'T est111' -Verbose #-UserType Employee
#Add-FederatedDirectoryUser -UserName 'TestUser1@test.pl' -DisplayName 'TestUser' -Verbose

#Add-FederatedDirectoryUser -UserName 'TestUser2@test.pl' -DisplayName 'TestUser' -Verbose -ManagerUserName 'TestUser1@test.pl'

for ($i = 1; $i -le 10; $i++) {
    Add-FederatedDirectoryUser -UserName "TestUserNew$i@test.pl" -DisplayName "TestUserNew$i" -ManagerDisplayName 'TestUser' -Suppress
}