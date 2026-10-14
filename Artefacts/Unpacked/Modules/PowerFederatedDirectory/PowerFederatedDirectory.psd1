@{
    AliasesToExport      = @('Add-FDUser', 'Connect-FD', 'Get-FDSchema', 'Get-FDUser', 'Remove-FDUser', 'Set-FDUser')
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2026 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'PowerShell module for Federated Directory.'
    FunctionsToExport    = @('Add-FederatedDirectoryUser', 'Connect-FederatedDirectory', 'Get-FederatedDirectorySchema', 'Get-FederatedDirectoryUser', 'Invoke-FederatedDirectory', 'Remove-FederatedDirectoryUser', 'Set-FederatedDirectoryUser')
    GUID                 = 'b73875b9-d87b-4a10-8cb5-0980d180c05b'
    ModuleVersion        = '0.0.12'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags                       = @('Windows', 'macOS', 'Linux', 'FederatedDirectory')
            ProjectUri                 = 'https://github.com/EvotecIT/PowerFederatedDirectory'
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
        }
    }
    RequiredModules      = @()
    RootModule           = 'PowerFederatedDirectory.psm1'
}