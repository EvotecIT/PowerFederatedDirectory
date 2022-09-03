@{
    AliasesToExport      = @()
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2022 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = ''
    FunctionsToExport    = @('Connect-FederatedDirectory', 'Get-FederatedDirectoryUser')
    GUID                 = 'b73875b9-d87b-4a10-8cb5-0980d180c05b'
    ModuleVersion        = '0.0.1'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags = @('Windows')
        }
    }
    RequiredModules      = @(@{
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
            ModuleVersion = '0.0.242'
            ModuleName    = 'PSSharedGoods'
        })
    RootModule           = 'PowerFederatedDirectory.psm1'
}