Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Suppress

# this doesn't really work as filter on manger is not supported
Get-FederatedDirectoryUser -Verbose -Attributes 'id', 'userName', 'phoneNumbers', 'groups', 'employeeNumber' -Filter "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager eq 'przemyslaw'" | Format-List *