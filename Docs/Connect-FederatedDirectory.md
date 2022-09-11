---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version:
schema: 2.0.0
---

# Connect-FederatedDirectory

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### ClearText (Default)
```
Connect-FederatedDirectory -Token <String> [-ExpiresTimeout <Int32>] [-ForceRefresh] [-Suppress]
 [<CommonParameters>]
```

### Encrypted
```
Connect-FederatedDirectory -TokenEncrypted <String> [-ExpiresTimeout <Int32>] [-ForceRefresh] [-Suppress]
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

### -ExpiresTimeout
{{ Fill ExpiresTimeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForceRefresh
{{ Fill ForceRefresh Description }}

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

### -Token
{{ Fill Token Description }}

```yaml
Type: String
Parameter Sets: ClearText
Aliases: ApplicationSecret, ApplicationKey

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TokenEncrypted
{{ Fill TokenEncrypted Description }}

```yaml
Type: String
Parameter Sets: Encrypted
Aliases: ApplicationSecretEncrypted, ApplicationKeyEncrypted

Required: True
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
