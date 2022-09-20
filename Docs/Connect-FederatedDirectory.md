---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version:
schema: 2.0.0
---

# Connect-FederatedDirectory

## SYNOPSIS
Connects to a federated directory.

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
Connects to a federated directory.

## EXAMPLES

### EXAMPLE 1
```
$Token = 'TokenInformation'
Connect-FederatedDirectory -Token $Token -Suppress
```

## PARAMETERS

### -Token
The token to use for authentication to the federated directory from New-JWT command.
This is the default.

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
The encrypted token to use for authentication to the federated directory from New-JWT command.

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

### -ExpiresTimeout
The number of seconds before the token expires.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForceRefresh
Forces a refresh of the authentication

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Suppress
Suppresses the output of the command.
By default the command will output the connection information.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
