function Invoke-FederatedDirectory {
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $Authorization,
        [Array] $Operations
    )
    if (-not $Authorization) {
        if ($Script:AuthorizationCacheFD) {
            $Authorization = $Script:AuthorizationCacheFD[0]
        }
        if (-not $Authorization) {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                throw "No authorization found. Please run 'Connect-FederatedDirectory' first."
            } else {
                Write-Warning -Message "Invoke-FederatedDirectory - No authorization found. Please run 'Connect-FederatedDirectory' first."
                return
            }
        }
    }
    if ($Authorization) {
        [Array] $SplitOperations = Split-Array -Objects $Operations -Size 5
        foreach ($O in $SplitOperations) {
            $Body = [ordered] @{
                schemas    = @('urn:ietf:params:scim:api:messages:2.0:BulkRequest')
                Operations = $O
            }
            Remove-EmptyValue -Hashtable $Body -Recursive -Rerun 2
            Try {
                $invokeRestMethodSplat = [ordered] @{
                    Method      = 'POST'
                    Uri         = 'https://api.federated.directory/v2/Bulk'
                    Headers     = [ordered]  @{
                        'Content-Type'  = 'application/json; charset=utf-8'
                        'Authorization' = $Authorization.Authorization
                        'Cache-Control' = 'no-cache'
                    }
                    Body        = $Body | ConvertTo-Json -Depth 10
                    ErrorAction = 'Stop'
                    ContentType = 'application/json; charset=utf-8'
                }
                if ($DirectoryID) {
                    $invokeRestMethodSplat['Headers']['directoryId'] = $DirectoryID
                }
                # for troubleshooting
                if ($VerbosePreference -eq 'Continue') {
                    $Body | ConvertTo-Json -Depth 10 | Write-Verbose
                }
                if ($PSCmdlet.ShouldProcess("Federated Directory", "Bulk sending $($O.Count) operations")) {
                    $ReturnData = Invoke-RestMethod @invokeRestMethodSplat -Verbose:$false
                    # don't return data as we trust it's been created
                    if (-not $Suppress) {
                        $ReturnData.Operations #.Response
                    }
                }
                # # for troubleshooting
                # if ($VerbosePreference -eq 'Continue') {
                #     $invokeRestMethodSplat.Remove('body')
                #     $invokeRestMethodSplat | ConvertTo-Json -Depth 10 | Write-Verbose
                # }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
                    Write-Warning -Message "Invoke-FederatedDirectory - Error $($_.Exception.Message), $($ErrorDetails.Detail)"
                }
            }
        }
    } else {
        Write-Warning -Message 'Invoke-FederatedDirectory - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}