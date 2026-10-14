param(
    [ValidateSet('Manifest', 'Build')][string] $RunMode = 'Build',
    [bool] $SignModule = $false,
    [string] $PackageRoot = (Join-Path $PSScriptRoot '../Artefacts')
)
Import-Module PSPublishModule -MinimumVersion 3.0.153 -Force
Invoke-ModuleBuild -ModuleName 'PowerFederatedDirectory' -RunMode $RunMode -SkipInstall -NoInteractive {
    New-ConfigurationManifest -ModuleVersion '0.0.12' -CompatiblePSEditions Desktop, Core `
        -Guid 'b73875b9-d87b-4a10-8cb5-0980d180c05b' -Author 'Przemyslaw Klys' -CompanyName Evotec `
        -Copyright "(c) 2011 - $((Get-Date).Year) Przemyslaw Klys @ Evotec. All rights reserved." `
        -Description 'PowerShell module for Federated Directory.' -PowerShellVersion '5.1' `
        -Tags Windows, macOS, Linux, FederatedDirectory -ProjectUri 'https://github.com/EvotecIT/PowerFederatedDirectory'
    New-ConfigurationModule -Type RequiredModule -Name PSSharedGoods -Guid Auto -RequiredVersion '0.0.313' -VersionSource PSGallery
    New-ConfigurationModule -Type ApprovedModule -Name PSSharedGoods, PSWriteColor
    New-ConfigurationModuleSkip -IgnoreFunctionName IsOfType, IsNumeric -IgnoreModuleName Microsoft.PowerShell.Utility, Microsoft.PowerShell.Management, Microsoft.PowerShell.Security
    New-ConfigurationImportModule -ImportSelf -ImportRequiredModules
    New-ConfigurationBuild -Enable -SignModule:$SignModule -MergeModuleOnBuild -MergeFunctionsFromApprovedModules
    New-ConfigurationArtefact -Type Unpacked -Enable -Path (Join-Path $PackageRoot 'Unpacked') -ModulesPath Modules -RequiredModulesPath Modules -AddRequiredModules
    New-ConfigurationArtefact -Type Packed -Enable -Path (Join-Path $PackageRoot 'Packed') -ArtefactName '<ModuleName>.v<ModuleVersion>.zip'
}
