param([string] $Token = $env:FEDERATED_DIRECTORY_TOKEN)
Import-Module PowerFederatedDirectory -ErrorAction Stop
if (-not $Token) { throw 'Provide Token or set FEDERATED_DIRECTORY_TOKEN.' }
Connect-FederatedDirectory -Token $Token -Suppress
Get-FederatedDirectoryUser -Attributes id, userName, displayName, employeeNumber |
    Format-Table Id, UserName, DisplayName, EmployeeNumber
Get-FederatedDirectoryUser -EmployeeNumber 'employee-42'
# Filter literals are quoted. Supply the directory identifier when selecting another directory.
Get-FederatedDirectoryUser -DirectoryID 'directory-id' -Filter 'id eq "user-id"'
