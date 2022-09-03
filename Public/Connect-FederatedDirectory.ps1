function Connect-FederatedDirectory {
    [alias('Connect-FD')]
    [cmdletbinding(DefaultParameterSetName = 'ClearText')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ClearText')]
        [alias('ApplicationSecret', 'ApplicationKey')]
        [string] $Token,

        [Parameter(Mandatory, ParameterSetName = 'Encrypted')]
        [alias('ApplicationSecretEncrypted', 'ApplicationKeyEncrypted')]
        [string] $TokenEncrypted,

        [int] $ExpiresTimeout = 30,
        [switch] $ForceRefresh,
        [switch] $Suppress
    )
    if (-not $Script:AuthorizationCacheFD) {
        $Script:AuthorizationCacheFD = [ordered] @{}
    }

    if ($TokenEncrypted) {
        try {
            $ApplicationKeyTemp = $ClientSecretEncrypted | ConvertTo-SecureString -ErrorAction Stop
        } catch {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                throw
            } else {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                Write-Warning -Message "Connect-ILM - Error: $ErrorMessage"
                return
            }
        }
        $ApplicationKey = [System.Net.NetworkCredential]::new([string]::Empty, $ApplicationKeyTemp).Password
    } else {
        $ApplicationKey = $Token
    }

    $ShortKey = $ApplicationKey.Trim(15)

    $RestSplat = @{
        ErrorAction = 'Stop'
        Method      = 'POST'
        Body        = @{
            "grant_type" = "urn:ietf:params:oauth:grant-type:jwt-bearer"
            "assertion"  = $ApplicationKey
        }
        Uri         = 'https://api.federated.directory/v2/Login/Oauth2/Token'
    }

    if ($Script:AuthorizationCacheFD[$ShortKey] -and -not $ForceRefesh) {
        if ($Script:AuthorizationCacheFD[$ShortKey].ExpiresOn -gt [datetime]::UtcNow) {
            Write-Verbose "Connect-FederatedDirectory - Using cache for $ShortKey..."
            if (-not $Suppress) {
                return $Script:AuthorizationCacheFD[$ShortKey]
            }
        }
    }

    try {
        $Authorization = Invoke-RestMethod @RestSplat
        $Key = [ordered] @{
            'Authorization' = "$($Authorization.token_type) $($Authorization.access_token)"
            'Extended'      = $Authorization
            'Error'         = ''
            'ExpiresOn'     = ([datetime]::UtcNow).AddSeconds($Authorization.expires_in - $ExpiresTimeout)
            'Splat'         = [ordered] @{
                Token = $RestSplat['Body']['assertion']
            }
            'Platform'      = $Platform
        }
        $Script:AuthorizationCacheFD[$ShortKey] = $Key
    } catch {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw
        } else {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            Write-Warning -Message "Connect-ILM - Error: $ErrorMessage"
            $Key = [ordered] @{
                'Authorization' = $Null
                'Extended'      = $Null
                'Error'         = $ErrorMessage
                'ExpiresOn'     = $null
                'Splat'         = [ordered] @{
                    Token = $RestSplat['Body']['assertion']
                }
                'Platform'      = $Platform
            }
        }
    }
    if (-not $Suppress) {
        $Key
    }
}