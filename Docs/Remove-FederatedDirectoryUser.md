---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version: https://github.com/EvotecIT/PowerFederatedDirectory
schema: 2.0.0
---
# Remove-FederatedDirectoryUser
## SYNOPSIS
Remove a user from a federated directory.

## SYNTAX
### Id (Default)
```powershell
Remove-FederatedDirectoryUser -Id <string[]> [-Authorization <IDictionary>] [-DirectoryID <string>] [-BulkProcessing] [-Suppress] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### User
```powershell
Remove-FederatedDirectoryUser [-User] <psobject[]> [-Authorization <IDictionary>] [-DirectoryID <string>] [-BulkProcessing] [-Suppress] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### UserName
```powershell
Remove-FederatedDirectoryUser -SearchUserName <string[]> [-Authorization <IDictionary>] [-DirectoryID <string>] [-BulkProcessing] [-Suppress] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### All
```powershell
Remove-FederatedDirectoryUser [-Authorization <IDictionary>] [-DirectoryID <string>] [-BulkProcessing] [-Suppress] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a user from a federated directory.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > # remove specific user id
Remove-FederatedDirectoryUser -Id '171a8cd0-2382-11ed-9dd1-b13400d703b6' -Verbose
```


### EXAMPLE 2
```powershell
PS > # get all ther users that contain name test user and delete them
Remove-FederatedDirectoryUser -UserName 'testuser' -Verbose
```


### EXAMPLE 3
```powershell
PS > # get all ther users that contain name test user and delete them
Get-FederatedDirectoryUser -UserName 'testuser' | Remove-FederatedDirectoryUser -Verbose
```


## PARAMETERS

### -All
Remove all users from the directory.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Authorization
The authorization identity to use for the request from Connect-FederatedDirectory. If not specified, the default authorization identity will be used.

```yaml
Type: IDictionary
Parameter Sets: Id, User, UserName, All
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BulkProcessing
Specifies the bulk processing switch.

```yaml
Type: SwitchParameter
Parameter Sets: Id, User, UserName, All
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DirectoryID
The id of the directory to remove the user from. If not specified, the default directory will be used.

```yaml
Type: String
Parameter Sets: Id, User, UserName, All
Aliases: None
Possible values:

Required: False
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The id of the user to remove from the federated directory.

```yaml
Type: String[]
Parameter Sets: Id
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchUserName
The user name of the user to remove from the federated directory.

```yaml
Type: String[]
Parameter Sets: UserName
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Suppress
Specifies the suppress switch.

```yaml
Type: SwitchParameter
Parameter Sets: Id, User, UserName, All
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to remove from the federated directory.

```yaml
Type: PSObject[]
Parameter Sets: User
Aliases: None
Possible values:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `PSObject[]`

## OUTPUTS

- `None`

## RELATED LINKS

- None
