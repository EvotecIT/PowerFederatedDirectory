param([string] $Token = $env:FEDERATED_DIRECTORY_TOKEN)
Import-Module PowerFederatedDirectory -ErrorAction Stop
if (-not $Token) { throw 'Provide Token or set FEDERATED_DIRECTORY_TOKEN.' }
Connect-FederatedDirectory -Token $Token -Suppress
$attributes = 'id', 'externalId', 'userName', 'givenName', 'familyName', 'displayName', 'emails'
Get-FederatedDirectoryUser -Attributes $attributes |
    Format-Table Id, UserName, DisplayName, EmailAddress
