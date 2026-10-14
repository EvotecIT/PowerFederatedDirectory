<#
.SYNOPSIS
Runs the module's standard build entry point.
#>
param(
    [Alias('RunMode')]
    [ValidateSet('Manifest', 'Build', 'Publish')]
    [string] $ConfigurationGateMode = 'Build',
    [bool] $SignModule = $true,
    [switch] $SkipInstall,
    [string] $PackageRoot = 'Artefacts',
    [string] $CertificateThumbprint,
    [string] $PowerShellGalleryApiKeyPath,
    [string] $GitHubApiKeyPath
)

& (Join-Path $PSScriptRoot 'Build-Module.ps1') @PSBoundParameters
