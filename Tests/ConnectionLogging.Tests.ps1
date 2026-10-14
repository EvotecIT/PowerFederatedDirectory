BeforeAll {
    . (Join-Path $PSScriptRoot '../Public/Connect-FederatedDirectory.ps1')
    . (Join-Path $PSScriptRoot '../Public/Get-FederatedDirectoryUser.ps1')
    function Remove-EmptyValue { param($Hashtable, [switch] $Recursive) }
    function Join-UriQuery { param($BaseUri, $QueryParameter) $BaseUri }
    function Invoke-RestMethod { [CmdletBinding()] param($Method, $Body, $Uri, $Headers, $ContentType) }
}

Describe 'Federated Directory cached authorization diagnostics' {
    It 'keeps <Mode> credentials out of verbose cache messages' -ForEach @(
        @{ Mode = 'plaintext'; Encrypted = $false; Suppress = $false },
        @{ Mode = 'encrypted'; Encrypted = $true; Suppress = $false },
        @{ Mode = 'suppressed'; Encrypted = $false; Suppress = $true }
    ) {
        $token = 'synthetic-test-token-012345'
        $script:AuthorizationCacheFD = [ordered] @{}
        Mock Invoke-RestMethod { @{ token_type = 'Bearer'; access_token = 'synthetic-authorization'; expires_in = 3600 } }
        $null = Connect-FederatedDirectory -Token $token

        Mock Invoke-RestMethod { throw 'Unexpected network call' }
        $parameters = @{ Verbose = $true; Suppress = $Suppress }
        if ($Encrypted) { $parameters.TokenEncrypted = ConvertTo-SecureString $token -AsPlainText -Force | ConvertFrom-SecureString }
        else { $parameters.Token = $token }
        $records = @(Connect-FederatedDirectory @parameters 4>&1)
        $verbose = @($records | Where-Object { $_ -is [Management.Automation.VerboseRecord] })
        $verbose | Should -HaveCount 1
        [string] $verbose[0] | Should -Match 'Using cached authorization'
        [string] $verbose[0] | Should -Not -Match ([regex]::Escape($token))
        if (-not $Suppress) { @($records | Where-Object { $_ -is [Collections.IDictionary] })[0].Authorization | Should -Be 'Bearer synthetic-authorization' }
        Should -Invoke Invoke-RestMethod -Times 1 -Exactly
    }

    It 'honors an explicit refresh instead of reusing cached authorization' {
        $token = 'synthetic-test-token-012345'
        $script:AuthorizationCacheFD = [ordered] @{}
        Mock Invoke-RestMethod { @{ token_type = 'Bearer'; access_token = 'old'; expires_in = 3600 } }
        $null = Connect-FederatedDirectory -Token $token
        Mock Invoke-RestMethod { @{ token_type = 'Bearer'; access_token = 'synthetic-refreshed'; expires_in = 3600 } }
        $connection = Connect-FederatedDirectory -Token $token -ForceRefresh -ErrorAction Stop
        $connection.Authorization | Should -Be 'Bearer synthetic-refreshed'
        Should -Invoke Invoke-RestMethod -Times 2 -Exactly
    }

    It 'keeps directory identities separate and selects a cached directory for subsequent requests' {
        $script:AuthorizationCacheFD = [ordered] @{}
        $script:ObservedAuthorization = @()
        Mock Invoke-RestMethod {
            if ($Method -eq 'POST') { return @{ token_type = 'Bearer'; access_token = "synthetic-$($Body.directoryId)"; expires_in = 3600 } }
            $script:ObservedAuthorization += $Headers.Authorization
            [pscustomobject] @{ Schemas = @('synthetic'); id = 'one' }
        }
        $token = 'synthetic-shared-token'
        $null = Connect-FederatedDirectory -Token $token -DirectoryID 'A'
        Connect-FederatedDirectory -Token $token -DirectoryID 'B' -Suppress
        $null = Get-FederatedDirectoryUser -Native -ErrorAction Stop
        Connect-FederatedDirectory -Token $token -DirectoryID 'A' -Suppress
        $null = Get-FederatedDirectoryUser -Native -ErrorAction Stop
        $script:ObservedAuthorization | Should -Be @('Bearer synthetic-B', 'Bearer synthetic-A')
        Should -Invoke Invoke-RestMethod -Times 2 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }
}
