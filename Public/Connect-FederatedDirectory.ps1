function Connect-FederatedDirectory {
    <#
    .SYNOPSIS
    Connects to a federated directory.

    .DESCRIPTION
    Connects to a federated directory.

    .PARAMETER Token
    The token to use for authentication to the federated directory from New-JWT command. This is the default.

    .PARAMETER TokenEncrypted
    The encrypted token to use for authentication to the federated directory from New-JWT command.

    .PARAMETER ExpiresTimeout
    The number of seconds before the token expires.

    .PARAMETER ForceRefresh
    Forces a refresh of the authentication

    .PARAMETER Suppress
    Suppresses the output of the command. By default the command will output the connection information.

    .EXAMPLE
    $Token = 'TokenInformation'
    Connect-FederatedDirectory -Token $Token -Suppress

    .NOTES
    General notes
    #>
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
        [string] $DirectoryID,
        [switch] $Suppress
    )
    if (-not $Script:AuthorizationCacheFD) {
        $Script:AuthorizationCacheFD = [ordered] @{}
    }

    if ($TokenEncrypted) {
        try {
            $ApplicationKeyTemp = $TokenEncrypted | ConvertTo-SecureString -ErrorAction Stop
        } catch {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                throw
            } else {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                Write-Warning -Message "Connect-FederatedDirectory - Error: $ErrorMessage"
                return
            }
        }
        $ApplicationKey = [System.Net.NetworkCredential]::new([string]::Empty, $ApplicationKeyTemp).Password
    } else {
        $ApplicationKey = $Token
    }

    $CacheKey = "$($DirectoryID.Length):$DirectoryID$ApplicationKey"

    $RestSplat = @{
        ErrorAction = 'Stop'
        Method      = 'POST'
        Body        = @{
            "grant_type"  = "urn:ietf:params:oauth:grant-type:jwt-bearer"
            "assertion"   = $ApplicationKey
            "directoryId" = $DirectoryID
        }
        Uri         = 'https://api.federated.directory/v2/Login/Oauth2/Token'
    }
    Remove-EmptyValue -Hashtable $RestSplat -Recursive
    if ($Script:AuthorizationCacheFD[$CacheKey] -and -not $ForceRefresh) {
        if ($Script:AuthorizationCacheFD[$CacheKey].ExpiresOn -gt [datetime]::UtcNow) {
            $CachedAuthorization = $Script:AuthorizationCacheFD[$CacheKey]
            $Script:AuthorizationCacheFD.Remove($CacheKey)
            $Script:AuthorizationCacheFD.Insert(0, $CacheKey, $CachedAuthorization)
            Write-Verbose 'Connect-FederatedDirectory - Using cached authorization.'
            if (-not $Suppress) {
                return $CachedAuthorization
            }
            return
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
        if ($Script:AuthorizationCacheFD.Contains($CacheKey)) { $Script:AuthorizationCacheFD.Remove($CacheKey) }
        $Script:AuthorizationCacheFD.Insert(0, $CacheKey, $Key)
    } catch {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw
        } else {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            Write-Warning -Message "Connect-FederatedDirectory - Error: $ErrorMessage"
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
