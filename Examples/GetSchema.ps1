Import-Module .\PowerFederatedDirectory.psd1 -Force

# moving description to the end so it doesn't obstruct the output of the command
$ColumnNames = @(
    'name'
    'type'
    'multiValued'
    'required'
    'caseExact'
    'mutability'
    'returned'
    'uniqueness'
    'minLength'
    'maxLength'
    'pattern'
    'subAttributes'
    'description'
)

$Schema = Get-FederatedDirectorySchema
$Schema | Where-Object { $_.Name -eq 'User' } | Select-Object -ExpandProperty Attributes | Format-Table -Property $ColumnNames
$Schema | Where-Object { $_.Name -eq 'EnterpriseUser' } | Select-Object -ExpandProperty Attributes | Format-Table -Property $ColumnNames
(($Schema | Where-Object { $_.Name -eq 'EnterpriseUser' } | Select-Object -ExpandProperty Attributes) | Where-Object { $_.Name -eq 'Manager' }).SubAttributes | Format-Table -Property $ColumnNames
$Schema | Where-Object { $_.Name -eq 'FederatedDirectoryUser' } | Select-Object -ExpandProperty Attributes | Format-Table -Property $ColumnNames

# or by html if you have PSWriteHTML module installed

New-HTML {
    $UserSchema = $Schema | Where-Object { $_.Name -eq 'User' } | Select-Object -ExpandProperty Attributes
    New-HTMLTable -DataTable $UserSchema -ScrollX
    $EnterpriseUser = $Schema | Where-Object { $_.Name -eq 'EnterpriseUser' } | Select-Object -ExpandProperty Attributes
    New-HTMLTable -DataTable $UserSchema -ScrollX
    $Schema | Where-Object { $_.Name -eq 'FederatedDirectoryUser' } | Select-Object -ExpandProperty Attributes
    New-HTMLTable -DataTable $UserSchema -ScrollX
}