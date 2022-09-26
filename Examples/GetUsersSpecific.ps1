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
)


$Users = Get-FederatedDirectoryUser -Verbose -SearchExternalID 've' -Attributes $Attributes
$Users | Format-Table

$Users = Get-FederatedDirectoryUser -Verbose -SearchUserName 've' -Attributes $Attributes
$Users | Format-Table