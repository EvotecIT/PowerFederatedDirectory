param([string] $ModuleRoot = (Join-Path $PSScriptRoot '../Artefacts/Unpacked/Modules/PowerFederatedDirectory'))
$ErrorActionPreference = 'Stop'
$ModuleRoot = (Resolve-Path -LiteralPath $ModuleRoot -ErrorAction Stop).ProviderPath
# Background jobs use the current PowerShell edition and keep synthetic handlers out of the caller's session.
$job = Start-Job -FilePath (Join-Path $PSScriptRoot 'Tests/Assert-Package.ps1') -ArgumentList $ModuleRoot
try {
    if (-not (Wait-Job -Job $job -Timeout 120)) {
        throw 'Package validation did not finish within 120 seconds.'
    }
    Receive-Job -Job $job -ErrorAction Stop
    if ($job.State -ne 'Completed') { throw 'Package validation failed.' }
} finally {
    if ($job.State -eq 'Running') { Stop-Job -Job $job }
    Remove-Job -Job $job
}
