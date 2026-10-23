param(
    [Alias('RunMode')]
    [ValidateSet('Manifest', 'Build', 'Publish')]
    [string] $ConfigurationGateMode = 'Build',
    [bool] $SignModule = $true,
    [switch] $SkipInstall,
    [string] $PackageRoot = 'Artefacts',
    [string] $CertificateThumbprint = '92E95FB58EFFA6A4A75E77A33CDD6BFE6DD30F1A',
    [string] $PowerShellGalleryApiKeyPath = (Join-Path $HOME '.config/evotec/psgallery-api-key.txt'),
    [string] $GitHubApiKeyPath = (Join-Path $HOME '.config/evotec/github-api-key.txt')
)

Import-Module PSPublishModule -MinimumVersion 3.0.176 -Force -ErrorAction Stop

Build-Module -ModuleName 'PowerFederatedDirectory' {
    New-ConfigurationManifest -ModuleVersion '0.0.13' -CompatiblePSEditions Desktop, Core `
        -Guid 'b73875b9-d87b-4a10-8cb5-0980d180c05b' -Author 'Przemyslaw Klys' -CompanyName Evotec `
        -Copyright "(c) 2011 - $((Get-Date).Year) Przemyslaw Klys @ Evotec. All rights reserved." `
        -Description 'PowerShell module for Federated Directory.' -PowerShellVersion '5.1' `
        -Tags Windows, macOS, Linux, FederatedDirectory -ProjectUri 'https://github.com/EvotecIT/PowerFederatedDirectory'
    New-ConfigurationGate -Mode $ConfigurationGateMode
    New-ConfigurationModule -Type RequiredModule -Name PSSharedGoods -Guid Auto -RequiredVersion '0.0.313' -VersionSource PSGallery
    New-ConfigurationModule -Type ApprovedModule -Name PSSharedGoods, PSWriteColor
    New-ConfigurationModuleSkip -IgnoreFunctionName IsOfType, IsNumeric -IgnoreModuleName Microsoft.PowerShell.Utility, Microsoft.PowerShell.Management, Microsoft.PowerShell.Security
    New-ConfigurationFormat -ApplyTo OnMergePSM1, OnMergePSD1 -EnableFormatting -PSD1Style Minimal
    New-ConfigurationImportModule -ImportSelf -ImportRequiredModules
    New-ConfigurationTest -TestsPath 'Tests' -Enable
    New-ConfigurationDocumentation -Enable -Path Docs -PathReadme Docs/Readme.md
    New-ConfigurationBuild -Enable -SignModule:$SignModule -CertificateThumbprint $CertificateThumbprint -MergeModuleOnBuild -MergeFunctionsFromApprovedModules -LocalVersioning:$false
    New-ConfigurationArtefact -Type Unpacked -Enable -Path (Join-Path $PackageRoot 'Unpacked') -ModulesPath Modules -RequiredModulesPath Modules -AddRequiredModules
    New-ConfigurationArtefact -Type Packed -Enable -Path (Join-Path $PackageRoot 'Packed') -ArtefactName '<ModuleName>.v<ModuleVersion>.zip'
    New-ConfigurationPublish -Type PowerShellGallery -FilePath $PowerShellGalleryApiKeyPath -Enabled
    New-ConfigurationPublish -Type GitHub -FilePath $GitHubApiKeyPath -UserName EvotecIT -RepositoryName 'PowerFederatedDirectory' -GenerateReleaseNotes -Enabled
} -SkipInstall:$SkipInstall -NoInteractive -ExitCode
