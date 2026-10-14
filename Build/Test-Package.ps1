param(
    [string] $ModuleRoot = (Join-Path $PSScriptRoot '../Artefacts/Unpacked/Modules/PowerFederatedDirectory'),
    [string] $ModuleName = 'PowerFederatedDirectory'
)
$ErrorActionPreference = 'Stop'
$env:PSModulePath = (Split-Path -Parent $ModuleRoot) + [IO.Path]::PathSeparator + (Join-Path $PSHOME 'Modules')
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -Force
$module = Get-Module $ModuleName
& $module {
    $script:NetworkCalls = 0
    function script:Invoke-RestMethod {
        [CmdletBinding()] param($Method, $Body, $Uri, $Headers, $ContentType)
        $script:NetworkCalls++
        if ($Method -eq 'Get') {
            $script:GetCalls++
            if ($script:FailLaterPage -and $script:GetCalls -eq 2) { throw 'synthetic-later-page-failure' }
            $start = [int] [regex]::Match([string] $Uri, 'startIndex=(\d+)').Groups[1].Value
            $end = [math]::Min($start + 499, 1001)
            return [pscustomobject] @{ StartIndex = $start; TotalResults = 1001; Resources = @($start..$end | ForEach-Object { [pscustomobject] @{ id = "user-$_" } }) }
        }
        @{ token_type = 'Bearer'; access_token = 'synthetic-refreshed'; expires_in = 3600 }
    }
    $token = 'synthetic-token-012345'
    $script:AuthorizationCacheFD = [ordered] @{}
    $null = Connect-FederatedDirectory -Token $token
    $records = @(Connect-FederatedDirectory -Token $token -Verbose 4>&1)
    $messages = @($records | Where-Object { $_ -is [Management.Automation.VerboseRecord] })
    if ($messages.Count -ne 1 -or [string] $messages[0] -like "*$token*" -or $script:NetworkCalls -ne 1) { throw 'Cached authorization logging contract failed' }
    $null = Connect-FederatedDirectory -Token $token -Suppress
    if ($script:NetworkCalls -ne 1) { throw 'Suppress did not reuse cached authorization' }
    $connection = Connect-FederatedDirectory -Token $token -ForceRefresh -ErrorAction Stop
    if ($script:NetworkCalls -ne 2 -or $connection.Authorization -ne 'Bearer synthetic-refreshed') { throw 'ForceRefresh did not refresh authorization' }
    $script:GetCalls = 0
    $script:FailLaterPage = $false
    $users = @(Get-FederatedDirectoryUser -Authorization $connection -Native -ErrorAction Stop)
    if ($users.Count -ne 1001 -or $users[-1].id -ne 'user-1001' -or $script:GetCalls -ne 3) { throw 'Packaged directory pagination was incomplete' }
    $script:GetCalls = 0
    $script:FailLaterPage = $true
    $failed = $false
    try { $users = @(Get-FederatedDirectoryUser -Authorization $connection -Native -ErrorAction Stop) }
    catch { $failed = $_.Exception.Message -eq 'synthetic-later-page-failure' }
    if (-not $failed -or $script:GetCalls -ne 2) { throw 'Packaged directory strict pagination failed' }
}
[pscustomobject] @{ Module = $ModuleName; Version = [string] $module.Version; PowerShell = [string] $PSVersionTable.PSVersion; CacheAndSafeLogging = 'PASS'; PaginationAndStrictFailure = 'PASS'; ExternalCalls = 0 } | ConvertTo-Json
