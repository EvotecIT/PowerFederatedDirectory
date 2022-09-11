Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Suppress

Get-FederatedDirectoryUser -Verbose -UserName 'BringFood@test.pl' | Format-Table *
Get-FederatedDirectoryUser -Verbose -Id 'd0795a50-300f-11ed-8f66-67bf21b5dbc9' -Attributes 'id', 'userName', 'phoneNumbers', 'groups' | Format-Table *
Get-FederatedDirectoryUser -Verbose -Attributes 'id', 'userName', 'phoneNumbers', 'groups', 'employeeNumber' | Format-List *
Get-FederatedDirectoryUser -Verbose | Format-List *
Get-FederatedDirectoryUser -Attributes id, userName, 'custom01', 'custom02', 'employeeNumber' -Verbose | Format-List *
Get-FederatedDirectoryUser -Attributes id, userName, 'custom01', 'custom02', 'employeeNumber' -Verbose -UserName 'BringFood@test.pl' | Format-List *
Get-FederatedDirectoryUser -Verbose -UserName 'BringFood@test.pl' | Format-Table *
Get-FederatedDirectoryUser -Filter "userName co Fal7" -Verbose | Format-Table *
Get-FederatedDirectoryUser -DirectoryID '7be46da1-237f-11ed-9dd1-b13400d703b6' -Filter "id eq b558c900-3013-11ed-8f66-67bf21b5dbc9" -Verbose | Format-Table *
Get-FederatedDirectoryUser -Filter "externalid eq b558c900-3013-11ed-8f66-67bf21b5dbc9" -Verbose | Format-Table *