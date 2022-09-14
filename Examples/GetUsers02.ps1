Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Suppress

$Attributes = @(
    'id'
    'externalId'
    'userName'
    'givenName'
    'familyName'
    'displayName'
    'nickName'
    'profileUrl'
    'title'
    'userType'
    'emails'
    'phoneNumbers'
    'addresses'
    'preferredLanguage'
    'locale'
    'timezone'
    'active'
    'groups'
    'roles'
    'meta'
    'organization'
    'employeeNumber'
    'costCenter'
    'division'
    'department'
    'manager'
    'description'
    'directoryId'
    'companyId'
    'companyLogos'
    'custom01'
    'custom02'
    'custom03'
    'meta'
)

Get-FederatedDirectoryUser -Verbose -Attributes $Attributes -UserName 'BringFood@test.pl' | Format-List *
#Get-FederatedDirectoryUser -Id 'd0795a50-300f-11ed-8f66-67bf21b5dbc9' -Verbose | Format-List *