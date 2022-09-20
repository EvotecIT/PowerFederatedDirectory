---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version:
schema: 2.0.0
---

# Remove-FederatedDirectoryUser

## SYNOPSIS
Remove a user from a federated directory.

## SYNTAX

### Id (Default)
```
Remove-FederatedDirectoryUser [-Authorization <IDictionary>] -Id <String[]> [-DirectoryID <String>]
 [-BulkProcessing] [-Suppress] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### User
```
Remove-FederatedDirectoryUser [-Authorization <IDictionary>] [-User] <PSObject[]> [-DirectoryID <String>]
 [-BulkProcessing] [-Suppress] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### UserName
```
Remove-FederatedDirectoryUser [-Authorization <IDictionary>] -SearchUserName <String[]> [-DirectoryID <String>]
 [-BulkProcessing] [-Suppress] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a user from a federated directory.

## EXAMPLES

### EXAMPLE 1
```
# remove specific user id
```

Remove-FederatedDirectoryUser -Id '171a8cd0-2382-11ed-9dd1-b13400d703b6' -Verbose

### EXAMPLE 2
```
# get all ther users that contain name test user and delete them
```

Remove-FederatedDirectoryUser -UserName 'testuser' -Verbose

### EXAMPLE 3
```
# get all ther users that contain name test user and delete them
```

Get-FederatedDirectoryUser -UserName 'testuser' | Remove-FederatedDirectoryUser -Verbose

## PARAMETERS

### -Authorization
The authorization identity to use for the request from Connect-FederatedDirectory.
If not specified, the default authorization identity will be used.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to remove from the federated directory.

```yaml
Type: PSObject[]
Parameter Sets: User
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id
The id of the user to remove from the federated directory.

```yaml
Type: String[]
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchUserName
The user name of the user to remove from the federated directory.

```yaml
Type: String[]
Parameter Sets: UserName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DirectoryID
The id of the directory to remove the user from.
If not specified, the default directory will be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Default value: False
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
Default value: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
