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

Get-FederatedDirectoryUser -Verbose -UserName 'BringFood@test.pl' -Native -Attributes $Attributes
Get-FederatedDirectoryUser -Id 'd0795a50-300f-11ed-8f66-67bf21b5dbc9' -Verbose -Native

<#


urn:ietf:params:scim:schemas:extension:enterprise:2.0:User : @{employeeNumber=EmployeeNumber; costCenter=CostCenter; organization=eurofins_test; division=Division My; department=Departament; manager=}
urn:ietf:params:scim:schemas:extension:fd:2.0:User         : @{description=dfsdf; directoryId=7be46da1-237f-11ed-9dd1-b13400d703b6; companyId=ff1db170-c706-11ec-bd4b-3d1c11ab3aa8; companyLogos=System.Object[]; custom01=Custom01 - ITZone ; custom02=Custom02 - right?}
meta                                                       : @{resourceType=User; location=https://api.federated.directory/v2/Users/d0795a50-300f-11ed-8f66-67bf21b5dbc9; created=2022-09-09T07:19:59.000Z; lastModified=2022-09-13T18:40:39.000Z}


urn:ietf:params:scim:schemas:extension:enterprise:2.0:User : @{employeeNumber=EmployeeNumber; costCenter=CostCenter; division=Division My; department=Departament; manager=}
urn:ietf:params:scim:schemas:extension:fd:2.0:User         : @{description=dfsdf; directoryId=7be46da1-237f-11ed-9dd1-b13400d703b6; companyId=ff1db170-c706-11ec-bd4b-3d1c11ab3aa8; custom01=Custom01 - ITZone ; custom02=Custom02 - right?}
#>

return
Get-FederatedDirectoryUser -Verbose -Id 'd0795a50-300f-11ed-8f66-67bf21b5dbc9' -Attributes 'id', 'userName', 'phoneNumbers', 'groups' | Format-Table *
Get-FederatedDirectoryUser -Verbose -Attributes 'id', 'userName', 'phoneNumbers', 'groups', 'employeeNumber' | Format-List *
Get-FederatedDirectoryUser -Verbose | Format-List *
Get-FederatedDirectoryUser -Attributes id, userName, 'custom01', 'custom02', 'employeeNumber' -Verbose | Format-List *
Get-FederatedDirectoryUser -Attributes id, userName, 'custom01', 'custom02', 'employeeNumber' -Verbose -UserName 'BringFood@test.pl' | Format-List *
Get-FederatedDirectoryUser -Verbose -UserName 'BringFood@test.pl' | Format-Table *
Get-FederatedDirectoryUser -Filter "userName co Fal7" -Verbose | Format-Table *
Get-FederatedDirectoryUser -DirectoryID '7be46da1-237f-11ed-9dd1-b13400d703b6' -Filter "id eq b558c900-3013-11ed-8f66-67bf21b5dbc9" -Verbose | Format-Table *
Get-FederatedDirectoryUser -Filter "externalid eq b558c900-3013-11ed-8f66-67bf21b5dbc9" -Verbose | Format-Table *