@{
    AliasesToExport      = @('Add-FDUser', 'Connect-FD', 'Get-FDSchema', 'Get-FDUser', 'Remove-FDUser', 'Set-FDUser')
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2022 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = ''
    FunctionsToExport    = @('Add-FederatedDirectoryUser', 'Connect-FederatedDirectory', 'Get-FederatedDirectorySchema', 'Get-FederatedDirectoryUser', 'Remove-FederatedDirectoryUser', 'Set-FederatedDirectoryUser')
    GUID                 = 'b73875b9-d87b-4a10-8cb5-0980d180c05b'
    ModuleVersion        = '0.0.1'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags       = @('Windows', 'macOS', 'Linux', 'Federated', 'Directory', 'FederatedDirectory')
            ProjectUri = 'https://github.com/EvotecIT/PowerFederatedDirectory'
            IconUri    = 'https://www.federated.directory/assets/icons/icon-144x144.png'
        }
    }
    RequiredModules      = @(@{
            ModuleVersion = '0.0.243'
            ModuleName    = 'PSSharedGoods'
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
        })
    RootModule           = 'PowerFederatedDirectory.psm1'
}