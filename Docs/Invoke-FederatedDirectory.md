---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version: https://github.com/EvotecIT/PowerFederatedDirectory
schema: 2.0.0
---
# Invoke-FederatedDirectory
## SYNOPSIS
Provides a way to invoke multiple operations on FederatedDirectory in a single request (bulk).

## SYNTAX
### __AllParameterSets
```powershell
Invoke-FederatedDirectory [[-Authorization] <IDictionary>] [[-Operations] <array>] [[-Size] <int>] [-ReturnHashtable] [-ReturnNative] [-Suppress] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Provides a way to invoke multiple operations on FederatedDirectory in a single request (bulk).
While the official limit is 1000 operations in a single request, it's actually much lower due to payload size

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Connect-FederatedDirectory -Token $Token -Suppress
```

$Operations = for ($i = 1; $i -le 1; $i++) {
    Add-FederatedDirectoryUser -UserName "TestNewwwww$i@test.pl" -DisplayName "TestUserNew$i" -ManagerDisplayName 'TestUser' -FamilyName 'Kłys' -GivenName 'Przemysłąw' -BulkProcessing
    #Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -FamilyName 'New namme' -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -Action Update -BulkProcessing
    Set-FederatedDirectoryUser -Id '0c50c6f0-3428-11ed-98e2-11027423d1f1' -DisplayName 'New name' -GivenName "Test" -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -UserName 'TestMe@verymuch.pl' -Action Overwrite -StreetAddress "Test me" -BulkProcessing
    Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -GivenName "Test" -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -UserName 'TestMe@verymuch.pl' -Action Overwrite -StreetAddress "Test me" -BulkProcessing
}
$Response = Invoke-FederatedDirectory -Operations $Operations -ReturnHashtable
$Response | Format-Table

## PARAMETERS

### -Authorization
The authorization identity to use for the request from Connect-FederatedDirectory. If not specified, the default authorization identity will be used.

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

### -Operations
Operations to perform as part of bulk request

```yaml
Type: Array
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnHashtable
Return results as a hashtable for quick matching BulkId

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

### -ReturnNative
Return results the same way REST API returns it

PARAMETER Suppress
Prevent returning results

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

### -Size
Batch size of operations to send in a single request. Default is 100.

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 2
Default value: 1000
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
Default value: False
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
