---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version:
schema: 2.0.0
---

# Get-FederatedDirectoryUser

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Get-FederatedDirectoryUser [[-Authorization] <IDictionary>] [[-Id] <String>] [[-SearchUserName] <String>]
 [[-SearchExternalID] <String>] [[-Search] <String>] [[-SearchProperty] <String>] [[-SearchOperator] <String>]
 [[-DirectoryID] <String>] [[-MaxResults] <Int32>] [[-StartIndex] <Int32>] [[-Count] <Int32>]
 [[-Filter] <String>] [[-SortBy] <String>] [[-SortOrder] <String>] [[-Attributes] <String[]>] [-Native]
 [<CommonParameters>]
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

### -Attributes
{{ Fill Attributes Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Property
Accepted values: id, externalId, userName, givenName, familyName, displayName, nickName, profileUrl, title, userType, emails, phoneNumbers, addresses, preferredLanguage, locale, timezone, active, groups, roles, meta, organization, employeeNumber, costCenter, division, department, manager, description, directoryId, companyId, companyLogos, custom01, custom02, custom03

Required: False
Position: 14
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

### -Count
{{ Fill Count Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
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
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
{{ Fill Filter Description }}

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

### -Id
{{ Fill Id Description }}

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

### -MaxResults
{{ Fill MaxResults Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Native
{{ Fill Native Description }}

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

### -Search
{{ Fill Search Description }}

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

### -SearchExternalID
{{ Fill SearchExternalID Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: ExternalID

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchOperator
{{ Fill SearchOperator Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchProperty
{{ Fill SearchProperty Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: id, externalId, userName, givenName, familyName, displayName, nickName, profileUrl, title, userType, emails, phoneNumbers, addresses, preferredLanguage, locale, timezone, active, groups, roles, meta, organization, employeeNumber, costCenter, division, department, manager, description, directoryId, companyId, companyLogos, custom01, custom02, custom03

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchUserName
{{ Fill SearchUserName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: UserName

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortBy
{{ Fill SortBy Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: id, externalId, userName, givenName, familyName, displayName, nickName, profileUrl, title, userType, emails, phoneNumbers, addresses, preferredLanguage, locale, timezone, active, groups, roles, meta, organization, employeeNumber, costCenter, division, department, manager, description, directoryId, companyId, companyLogos, custom01, custom02, custom03

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortOrder
{{ Fill SortOrder Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: ascending, descending

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartIndex
{{ Fill StartIndex Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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
