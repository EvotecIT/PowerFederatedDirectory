---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version: https://github.com/EvotecIT/PowerFederatedDirectory
schema: 2.0.0
---
# Add-FederatedDirectoryUser
## SYNOPSIS
Add-FederatedDirectoryUser [[-Authorization] <IDictionary>] [[-ExternalId] <string>] [[-DirectoryID] <string>] [-UserName] <string> [[-FamilyName] <Object>] [[-GivenName] <string>] [-DisplayName] <string> [[-NickName] <string>] [[-ProfileUrl] <string>] [[-EmailAddress] <string>] [[-EmailAddressHome] <string>] [[-StreetAddress] <string>] [[-City] <string>] [[-Region] <string>] [[-PostalCode] <string>] [[-Country] <string>] [[-StreetAddressHome] <string>] [[-PostalCodeHome] <string>] [[-CityHome] <string>] [[-RegionHome] <string>] [[-CountryHome] <string>] [[-PhoneNumberWork] <string>] [[-PhoneNumberHome] <string>] [[-PhoneNumberMobile] <string>] [[-PhotoUrl] <string>] [[-ThumbnailUrl] <string>] [[-CompanyID] <string>] [[-PreferredLanguage] <string>] [[-Locale] <string>] [[-TimeZone] <string>] [[-Title] <string>] [[-UserType] <string>] [[-Password] <string>] [[-ManagerID] <string>] [[-ManagerUserName] <string>] [[-ManagerDisplayName] <string>] [[-Department] <string>] [[-EmployeeNumber] <string>] [[-CostCenter] <string>] [[-Division] <string>] [[-Description] <string>] [[-Role] <string>] [[-Custom01] <string>] [[-Custom02] <string>] [[-Custom03] <string>] [-Active] [-Suppress] [-BulkProcessing] [-WhatIf] [-Confirm] [<CommonParameters>]

## SYNTAX
### __AllParameterSets
```powershell
Add-FederatedDirectoryUser [[-Authorization] <IDictionary>] [[-ExternalId] <string>] [[-DirectoryID] <string>] [-UserName] <string> [[-FamilyName] <Object>] [[-GivenName] <string>] [-DisplayName] <string> [[-NickName] <string>] [[-ProfileUrl] <string>] [[-EmailAddress] <string>] [[-EmailAddressHome] <string>] [[-StreetAddress] <string>] [[-City] <string>] [[-Region] <string>] [[-PostalCode] <string>] [[-Country] <string>] [[-StreetAddressHome] <string>] [[-PostalCodeHome] <string>] [[-CityHome] <string>] [[-RegionHome] <string>] [[-CountryHome] <string>] [[-PhoneNumberWork] <string>] [[-PhoneNumberHome] <string>] [[-PhoneNumberMobile] <string>] [[-PhotoUrl] <string>] [[-ThumbnailUrl] <string>] [[-CompanyID] <string>] [[-PreferredLanguage] <string>] [[-Locale] <string>] [[-TimeZone] <string>] [[-Title] <string>] [[-UserType] <string>] [[-Password] <string>] [[-ManagerID] <string>] [[-ManagerUserName] <string>] [[-ManagerDisplayName] <string>] [[-Department] <string>] [[-EmployeeNumber] <string>] [[-CostCenter] <string>] [[-Division] <string>] [[-Description] <string>] [[-Role] <string>] [[-Custom01] <string>] [[-Custom02] <string>] [[-Custom03] <string>] [-Active] [-Suppress] [-BulkProcessing] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add-FederatedDirectoryUser [[-Authorization] <IDictionary>] [[-ExternalId] <string>] [[-DirectoryID] <string>] [-UserName] <string> [[-FamilyName] <Object>] [[-GivenName] <string>] [-DisplayName] <string> [[-NickName] <string>] [[-ProfileUrl] <string>] [[-EmailAddress] <string>] [[-EmailAddressHome] <string>] [[-StreetAddress] <string>] [[-City] <string>] [[-Region] <string>] [[-PostalCode] <string>] [[-Country] <string>] [[-StreetAddressHome] <string>] [[-PostalCodeHome] <string>] [[-CityHome] <string>] [[-RegionHome] <string>] [[-CountryHome] <string>] [[-PhoneNumberWork] <string>] [[-PhoneNumberHome] <string>] [[-PhoneNumberMobile] <string>] [[-PhotoUrl] <string>] [[-ThumbnailUrl] <string>] [[-CompanyID] <string>] [[-PreferredLanguage] <string>] [[-Locale] <string>] [[-TimeZone] <string>] [[-Title] <string>] [[-UserType] <string>] [[-Password] <string>] [[-ManagerID] <string>] [[-ManagerUserName] <string>] [[-ManagerDisplayName] <string>] [[-Department] <string>] [[-EmployeeNumber] <string>] [[-CostCenter] <string>] [[-Division] <string>] [[-Description] <string>] [[-Role] <string>] [[-Custom01] <string>] [[-Custom02] <string>] [[-Custom03] <string>] [-Active] [-Suppress] [-BulkProcessing] [-WhatIf] [-Confirm] [<CommonParameters>]

## EXAMPLES

### EXAMPLE 1
```powershell
Add-FederatedDirectoryUser -UserName 'Name' -DisplayName 'Name'
```


## PARAMETERS

### -Active
Specifies the active switch.

```yaml
Type: SwitchParameter
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Authorization
Specifies one or more values for authorization.

```yaml
Type: IDictionary
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BulkProcessing
Specifies the bulk processing switch.

```yaml
Type: SwitchParameter
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -City
Specifies a value for city.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CityHome
Specifies a value for city home.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyID
Specifies a value for company id.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 26
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CostCenter
Specifies a value for cost center.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 38
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Country
Specifies a value for country.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CountryHome
Specifies a value for country home.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Custom01
Specifies a value for custom01.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: CustomAttribute01
Possible values:

Required: False
Position: 42
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Custom02
Specifies a value for custom02.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: CustomAttribute02
Possible values:

Required: False
Position: 43
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Custom03
Specifies a value for custom03.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: CustomAttribute03
Possible values:

Required: False
Position: 44
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Department
Specifies a value for department.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 36
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Specifies a value for description.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 40
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DirectoryID
Specifies a value for directory id.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayName
Specifies a value for display name.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Division
Specifies a value for division.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 39
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAddress
Specifies a value for email address.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAddressHome
Specifies a value for email address home.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmployeeNumber
Specifies a value for employee number.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 37
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalId
Specifies a value for external id.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FamilyName
Specifies a value for family name.

```yaml
Type: Object
Parameter Sets: __AllParameterSets
Aliases: FirstName
Possible values:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GivenName
Specifies a value for given name.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Locale
Specifies a value for locale.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 28
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagerDisplayName
Specifies a value for manager display name.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 35
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagerID
Specifies a value for manager id.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 33
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagerUserName
Specifies a value for manager user name.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 34
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NickName
Specifies a value for nick name.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Specifies a value for password.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 32
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PhoneNumberHome
Specifies a value for phone number home.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 22
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PhoneNumberMobile
Specifies a value for phone number mobile.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 23
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PhoneNumberWork
Specifies a value for phone number work.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 21
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PhotoUrl
Specifies a value for photo url.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 24
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PostalCode
Specifies a value for postal code.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PostalCodeHome
Specifies a value for postal code home.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreferredLanguage
Specifies a value for preferred language.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 27
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfileUrl
Specifies a value for profile url.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Region
Specifies a value for region.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RegionHome
Specifies a value for region home.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
Specifies a value for role.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values: admin, user

Required: False
Position: 41
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StreetAddress
Specifies a value for street address.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StreetAddressHome
Specifies a value for street address home.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Suppress
Specifies the suppress switch.

```yaml
Type: SwitchParameter
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThumbnailUrl
Specifies a value for thumbnail url.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 25
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeZone
Specifies a value for time zone.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 29
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Specifies a value for title.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 30
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
Specifies a value for user name.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserType
Specifies a value for user type.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 31
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `System.Object`

## RELATED LINKS

- None
