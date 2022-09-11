Import-Module .\PowerFederatedDirectory.psd1 -Force

$Schema = Get-FederatedDirectorySchema
$Schema | Where-Object { $_.Name -eq 'User' } | Select-Object -ExpandProperty Attributes | Format-Table
$Schema | Where-Object { $_.Name -eq 'EnterpriseUser' } | Select-Object -ExpandProperty Attributes | Format-Table
$Schema | Where-Object { $_.Name -eq 'FederatedDirectoryUser' } | Select-Object -ExpandProperty Attributes | Format-Table