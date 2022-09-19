---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version:
schema: 2.0.0
---

# Set-FederatedDirectoryUser

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Set-FederatedDirectoryUser [[-Authorization] <IDictionary>] [[-SearchUserName] <String>] [[-Id] <String>]
 [[-ExternalId] <String>] [[-DirectoryID] <String>] [[-UserName] <String>] [[-FamilyName] <Object>]
 [[-GivenName] <String>] [[-DisplayName] <String>] [[-NickName] <String>] [[-ProfileUrl] <String>]
 [[-EmailAddress] <String>] [[-EmailAddressHome] <String>] [[-StreetAddress] <String>] [[-City] <String>]
 [[-Region] <String>] [[-PostalCode] <String>] [[-Country] <String>] [[-StreetAddressHome] <String>]
 [[-PostalCodeHome] <String>] [[-CityHome] <String>] [[-RegionHome] <String>] [[-CountryHome] <String>]
 [[-PhoneNumberWork] <String>] [[-PhoneNumberHome] <String>] [[-PhoneNumberMobile] <String>]
 [[-PhotoUrl] <String>] [[-ThumbnailUrl] <String>] [[-CompanyID] <String>] [[-PreferredLanguage] <String>]
 [[-Locale] <String>] [[-TimeZone] <String>] [[-Title] <String>] [[-UserType] <String>] [[-Password] <String>]
 [[-ManagerID] <String>] [[-ManagerUserName] <String>] [[-ManagerReference] <String>]
 [[-ManagerDisplayName] <String>] [[-Active] <Boolean>] [[-Department] <String>] [[-EmployeeNumber] <String>]
 [[-CostCenter] <String>] [[-Division] <String>] [[-Description] <String>] [[-Role] <String>]
 [[-Custom01] <String>] [[-Custom02] <String>] [[-Custom03] <String>] [-Suppress] [[-Action] <String>]
 [[-ActionPerProperty] <IDictionary>] [-BulkProcessing] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Action
{{ Fill Action Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Overwrite, Update

Required: False
Position: 49
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionPerProperty
{{ Fill ActionPerProperty Description }}

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: False
Position: 50
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Active
{{ Fill Active Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 39
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Authorization
{{ Fill Authorization Description }}

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BulkProcessing
{{ Fill BulkProcessing Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -City
{{ Fill City Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CityHome
{{ Fill CityHome Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyID
{{ Fill CompanyID Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 28
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CostCenter
{{ Fill CostCenter Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 42
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Country
{{ Fill Country Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CountryHome
{{ Fill CountryHome Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Custom01
{{ Fill Custom01 Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: CustomAttribute01

Required: False
Position: 46
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Custom02
{{ Fill Custom02 Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: CustomAttribute02

Required: False
Position: 47
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Custom03
{{ Fill Custom03 Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: CustomAttribute03

Required: False
Position: 48
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Department
{{ Fill Department Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 40
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
{{ Fill Description Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 44
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DirectoryID
{{ Fill DirectoryID Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayName
{{ Fill DisplayName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Division
{{ Fill Division Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 43
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAddress
{{ Fill EmailAddress Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAddressHome
{{ Fill EmailAddressHome Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmployeeNumber
{{ Fill EmployeeNumber Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 41
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalId
{{ Fill ExternalId Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FamilyName
{{ Fill FamilyName Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases: FirstName

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GivenName
{{ Fill GivenName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
{{ Fill Id Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Locale
{{ Fill Locale Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 30
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagerDisplayName
{{ Fill ManagerDisplayName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 38
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagerID
{{ Fill ManagerID Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 35
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagerReference
{{ Fill ManagerReference Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 37
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagerUserName
{{ Fill ManagerUserName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 36
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NickName
{{ Fill NickName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
{{ Fill Password Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 34
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PhoneNumberHome
{{ Fill PhoneNumberHome Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 24
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PhoneNumberMobile
{{ Fill PhoneNumberMobile Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 25
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PhoneNumberWork
{{ Fill PhoneNumberWork Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 23
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PhotoUrl
{{ Fill PhotoUrl Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 26
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PostalCode
{{ Fill PostalCode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PostalCodeHome
{{ Fill PostalCodeHome Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreferredLanguage
{{ Fill PreferredLanguage Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 29
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfileUrl
{{ Fill ProfileUrl Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Region
{{ Fill Region Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RegionHome
{{ Fill RegionHome Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
{{ Fill Role Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: admin, user

Required: False
Position: 45
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchUserName
{{ Fill SearchUserName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StreetAddress
{{ Fill StreetAddress Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StreetAddressHome
{{ Fill StreetAddressHome Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Suppress
{{ Fill Suppress Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThumbnailUrl
{{ Fill ThumbnailUrl Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 27
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeZone
{{ Fill TimeZone Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 31
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
{{ Fill Title Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 32
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
{{ Fill UserName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserType
{{ Fill UserType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 33
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
