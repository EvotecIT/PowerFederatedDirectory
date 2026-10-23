---
Module Name: PowerFederatedDirectory
Module Guid: b73875b9-d87b-4a10-8cb5-0980d180c05b
Download Help Link: https://github.com/EvotecIT/PowerFederatedDirectory
Help Version: 0.0.12
Locale: en-US
---
# PowerFederatedDirectory Module
## Description
PowerShell module for Federated Directory.

## PowerFederatedDirectory Cmdlets
### [Add-FederatedDirectoryUser](Add-FederatedDirectoryUser.md)
Add-FederatedDirectoryUser [[-Authorization] <IDictionary>] [[-ExternalId] <string>] [[-DirectoryID] <string>] [-UserName] <string> [[-FamilyName] <Object>] [[-GivenName] <string>] [-DisplayName] <string> [[-NickName] <string>] [[-ProfileUrl] <string>] [[-EmailAddress] <string>] [[-EmailAddressHome] <string>] [[-StreetAddress] <string>] [[-City] <string>] [[-Region] <string>] [[-PostalCode] <string>] [[-Country] <string>] [[-StreetAddressHome] <string>] [[-PostalCodeHome] <string>] [[-CityHome] <string>] [[-RegionHome] <string>] [[-CountryHome] <string>] [[-PhoneNumberWork] <string>] [[-PhoneNumberHome] <string>] [[-PhoneNumberMobile] <string>] [[-PhotoUrl] <string>] [[-ThumbnailUrl] <string>] [[-CompanyID] <string>] [[-PreferredLanguage] <string>] [[-Locale] <string>] [[-TimeZone] <string>] [[-Title] <string>] [[-UserType] <string>] [[-Password] <string>] [[-ManagerID] <string>] [[-ManagerUserName] <string>] [[-ManagerDisplayName] <string>] [[-Department] <string>] [[-EmployeeNumber] <string>] [[-CostCenter] <string>] [[-Division] <string>] [[-Description] <string>] [[-Role] <string>] [[-Custom01] <string>] [[-Custom02] <string>] [[-Custom03] <string>] [-Active] [-Suppress] [-BulkProcessing] [-WhatIf] [-Confirm] [<CommonParameters>]

### [Connect-FederatedDirectory](Connect-FederatedDirectory.md)
Connects to a federated directory.

### [Get-FederatedDirectorySchema](Get-FederatedDirectorySchema.md)
Get the schema of a federated directory.

### [Get-FederatedDirectoryUser](Get-FederatedDirectoryUser.md)
Retrieves users and follows all advertised directory pages.

### [Invoke-FederatedDirectory](Invoke-FederatedDirectory.md)
Provides a way to invoke multiple operations on FederatedDirectory in a single request (bulk).

### [Remove-FederatedDirectoryUser](Remove-FederatedDirectoryUser.md)
Remove a user from a federated directory.

### [Set-FederatedDirectoryUser](Set-FederatedDirectoryUser.md)
Set-FederatedDirectoryUser [[-Authorization] <IDictionary>] [[-SearchUserName] <string>] [[-Id] <string>] [[-ExternalId] <string>] [[-DirectoryID] <string>] [[-UserName] <string>] [[-FamilyName] <Object>] [[-GivenName] <string>] [[-DisplayName] <string>] [[-NickName] <string>] [[-ProfileUrl] <string>] [[-EmailAddress] <string>] [[-EmailAddressHome] <string>] [[-StreetAddress] <string>] [[-City] <string>] [[-Region] <string>] [[-PostalCode] <string>] [[-Country] <string>] [[-StreetAddressHome] <string>] [[-PostalCodeHome] <string>] [[-CityHome] <string>] [[-RegionHome] <string>] [[-CountryHome] <string>] [[-PhoneNumberWork] <string>] [[-PhoneNumberHome] <string>] [[-PhoneNumberMobile] <string>] [[-PhotoUrl] <string>] [[-ThumbnailUrl] <string>] [[-CompanyID] <string>] [[-PreferredLanguage] <string>] [[-Locale] <string>] [[-TimeZone] <string>] [[-Title] <string>] [[-UserType] <string>] [[-Password] <string>] [[-ManagerID] <string>] [[-ManagerUserName] <string>] [[-ManagerReference] <string>] [[-ManagerDisplayName] <string>] [[-Active] <bool>] [[-Department] <string>] [[-EmployeeNumber] <string>] [[-CostCenter] <string>] [[-Division] <string>] [[-Description] <string>] [[-Role] <string>] [[-Custom01] <string>] [[-Custom02] <string>] [[-Custom03] <string>] [[-Action] <string>] [[-ActionPerProperty] <IDictionary>] [-Suppress] [-BulkProcessing] [-WhatIf] [-Confirm] [<CommonParameters>]
