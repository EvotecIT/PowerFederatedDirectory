param([string] $ModuleRoot = (Join-Path $PSScriptRoot '../Artefacts/Unpacked/Modules/PowerFederatedDirectory'))
$ErrorActionPreference = 'Stop'
if (Get-Module PowerFederatedDirectory) { throw 'Run package isolation checks in a fresh PowerShell process.' }
$originalPath = $env:PSModulePath
$originalJobs = @(Get-Job | Select-Object -ExpandProperty Id)
Import-Module (Join-Path $ModuleRoot 'PowerFederatedDirectory.psd1') -Force
$originalModule = Get-Module PowerFederatedDirectory
$marker = [guid]::NewGuid().ToString()
& $originalModule { param($value) $script:PackageIsolationMarker = $value } $marker
try {
    $result = & (Join-Path $PSScriptRoot 'Test-Package.ps1') -ModuleRoot $ModuleRoot | ConvertFrom-Json
    if ($result.PowerShell -ne [string] $PSVersionTable.PSVersion) { throw 'Package validation used a different PowerShell runtime.' }
    $failureObserved = $false
    # A module root without the required manifest makes the child fail after it changes its search path.
    try { & (Join-Path $PSScriptRoot 'Test-Package.ps1') -ModuleRoot $PSScriptRoot | Out-Null }
    catch { $failureObserved = $true }
    if (-not $failureObserved) { throw 'Package validation did not propagate the child failure.' }
    if ($env:PSModulePath -cne $originalPath) { throw 'Package validation changed the caller module search path.' }
    if (-not [object]::ReferenceEquals($originalModule, (Get-Module PowerFederatedDirectory))) { throw 'Package validation replaced the caller module.' }
    if ((& $originalModule { $script:PackageIsolationMarker }) -ne $marker) { throw 'Package validation changed the caller module state.' }
    if (@(Get-Job | Where-Object { $_.Id -notin $originalJobs }).Count) { throw 'Package validation left a background job behind.' }
    $result
} finally {
    & $originalModule { Remove-Variable -Name PackageIsolationMarker -Scope Script }
    Remove-Module -ModuleInfo $originalModule
}
