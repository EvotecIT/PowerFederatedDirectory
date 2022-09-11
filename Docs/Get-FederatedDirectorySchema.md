---
external help file: PowerFederatedDirectory-help.xml
Module Name: PowerFederatedDirectory
online version:
schema: 2.0.0
---

# Get-FederatedDirectorySchema

## SYNOPSIS
Get the schema of a federated directory.

## SYNTAX

```
Get-FederatedDirectorySchema [<CommonParameters>]
```

## DESCRIPTION
Get the schema of a federated directory.

## EXAMPLES

### EXAMPLE 1
```
$Schema = Get-FederatedDirectorySchema
```

$Schema | Where-Object { $_.Name -eq 'User' } | Select-Object -ExpandProperty Attributes | Format-Table
$Schema | Where-Object { $_.Name -eq 'EnterpriseUser' } | Select-Object -ExpandProperty Attributes | Format-Table
$Schema | Where-Object { $_.Name -eq 'FederatedDirectoryUser' } | Select-Object -ExpandProperty Attributes | Format-Table

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
