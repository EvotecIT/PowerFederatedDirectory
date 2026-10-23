param(
    [string] $Token = $env:FEDERATED_DIRECTORY_TOKEN,
    [Parameter(Mandatory)][string] $UserId,
    [string] $DisplayName = 'Example User',
    [string] $EmailAddress = 'user@example.test',
    [switch] $Apply
)
Import-Module PowerFederatedDirectory -ErrorAction Stop
if (-not $Token) { throw 'Provide Token or set FEDERATED_DIRECTORY_TOKEN.' }
Connect-FederatedDirectory -Token $Token -Suppress
Get-FederatedDirectoryUser -Id $UserId |
    Format-Table Id, UserName, DisplayName, EmailAddress, FamilyName, Country, Custom01
# Preview by default. Apply only after inspecting the selected account and intended values.
Set-FederatedDirectoryUser -Id $UserId -DisplayName $DisplayName -EmailAddress $EmailAddress -Action Update -WhatIf:(-not $Apply)
# Use Action Overwrite only when intentionally replacing the complete remote record.
