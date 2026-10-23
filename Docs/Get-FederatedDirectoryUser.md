---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version: https://github.com/EvotecIT/PowerFederatedDirectory
schema: 2.0.0
---
# Get-FederatedDirectoryUser
## SYNOPSIS
Retrieves users and follows all advertised directory pages.

## SYNTAX
### __AllParameterSets
```powershell
Get-FederatedDirectoryUser [[-Authorization] <IDictionary>] [[-Id] <string>] [[-SearchUserName] <string>] [[-SearchExternalID] <string>] [[-SearchEmployeeNumber] <string>] [[-Search] <string>] [[-SearchProperty] <string>] [[-SearchOperator] <string>] [[-DirectoryID] <string>] [[-MaxResults] <int>] [[-StartIndex] <int>] [[-Count] <int>] [[-Filter] <string>] [[-SortBy] <string>] [[-SortOrder] <string>] [[-Attributes] <string[]>] [-Native] [<CommonParameters>]
```

## DESCRIPTION
Retrieves users and follows all advertised directory pages.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Get-FederatedDirectoryUser -EmployeeNumber 'employee-42'
```


## PARAMETERS

### -Attributes
Specifies one or more values for attributes.

```yaml
Type: String[]
Parameter Sets: __AllParameterSets
Aliases: Property
Possible values: id, externalId, userName, givenName, familyName, displayName, nickName, profileUrl, title, userType, emails, phoneNumbers, addresses, preferredLanguage, locale, timezone, active, groups, roles, meta, organization, employeeNumber, costCenter, division, department, manager, description, directoryId, companyId, companyLogos, custom01, custom02, custom03

Required: False
Position: 15
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

### -Count
Specifies a value for count.

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 11
Default value: 1000
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
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Specifies a value for filter.

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

### -Id
Specifies a value for id.

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

### -MaxResults
Specifies a value for max results.

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 9
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Native
Specifies the native switch.

```yaml
Type: SwitchParameter
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Search
Specifies a value for search.

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

### -SearchEmployeeNumber
Matches the enterprise employee number exactly. EmployeeNumber is an alias.
User-name and external-ID selectors retain precedence when also supplied.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: EmployeeNumber
Possible values:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchExternalID
Specifies a value for search external id.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: ExternalID
Possible values:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchOperator
Specifies a value for search operator.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 7
Default value: eq
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchProperty
Specifies a value for search property.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values: id, externalId, userName, givenName, familyName, displayName, nickName, profileUrl, title, userType, emails, phoneNumbers, addresses, preferredLanguage, locale, timezone, active, groups, roles, meta, organization, employeeNumber, costCenter, division, department, manager, description, directoryId, companyId, companyLogos, custom01, custom02, custom03

Required: False
Position: 6
Default value: userName
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchUserName
Specifies a value for search user name.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: UserName
Possible values:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortBy
Specifies a value for sort by.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values: id, externalId, userName, givenName, familyName, displayName, nickName, profileUrl, title, userType, emails, phoneNumbers, addresses, preferredLanguage, locale, timezone, active, groups, roles, meta, organization, employeeNumber, costCenter, division, department, manager, description, directoryId, companyId, companyLogos, custom01, custom02, custom03

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortOrder
Specifies a value for sort order.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values: ascending, descending

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartIndex
Specifies a value for start index.

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 10
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None
